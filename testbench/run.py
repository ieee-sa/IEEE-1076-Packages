"""
VUnit run script for repository testbenches.
"""
from pathlib import Path
import re
from vunit import VUnit, VUnitCLI
from xml.etree import ElementTree

class IEEEPreprocessor:
    """
    Preprocessing of VHDL files to replace each reference to ieee with
    a reference to new_ieee such that the simulator implementation isn't used.
    An exception is std_logic since some of its functionality is "predefined"
    and not part of the package but only known by the simulator.
    """
    _ieee_use_pattern = re.compile(r'\s+(?P<library>ieee)\.(?P<package>\w+)',
                                   re.MULTILINE | re.IGNORECASE)
    _ieee_library_pattern = re.compile(r'(library\s+)ieee(\s*;)', re.MULTILINE | re.IGNORECASE)

    def run(self, code, file_name):
        """
        Called by VUnit for every VHDL file
        """
        new_code = self._ieee_library_pattern.sub(r'\1new_ieee, ieee\2', code)

        matches = list(self._ieee_use_pattern.finditer(new_code))
        matches.sort(key=lambda match: match.start('package'), reverse=True)
        for match in matches:
            if match.group('package').lower() != 'std_logic_1164':
                new_code = new_code[:match.start('library')] + 'new_ieee' + new_code[match.end('library'):]

        return new_code

def get_args(root):
    """
    Create and extract command line arguments
    """
    cli = VUnitCLI()
    cli.parser.add_argument('-s', '--vendor-verification',
                            action='store_true',
                            help='Use vendor ieee library for internal package references.')
    cli.parser.add_argument('-a', '--vhdl-assert-stop-level',
                            default="all",
                            choices=["all", "warning", "error", "failure"],
                            help=('VHDL assert stop level. "all" will use all levels.'))
    args = cli.parse_args()

    if args.xunit_xml is None:
        args.xunit_xml = str(root/"result.xml")

    xunit_xml_path = Path(args.xunit_xml)
    if xunit_xml_path.exists():
        xunit_xml_path.unlink()

    return args

def create_project(root, args):
    """
    Create VUnit project
    """
    prj = VUnit.from_args(args)

    if not args.vendor_verification:
        prj.add_preprocessor(IEEEPreprocessor())

    prj.enable_check_preprocessing()

    new_ieee = prj.add_library("new_ieee")
    if not args.vendor_verification:
        new_ieee.add_source_files(str(root/"../ieee/*.vhdl"))
    new_ieee.add_source_files(str(root/"*.vhdl"))

    # Work around pending VUnit dependency scanning updates
    test_fixed = new_ieee.get_source_files("*test_fixed.vhdl")
    test_fixed2 = new_ieee.get_source_files("*test_fixed2.vhdl")
    test_fixed3 = new_ieee.get_source_files("*test_fixed3.vhdl")
    test_fixed_nr = new_ieee.get_source_files("*test_fixed_nr.vhdl")
    test_fphdl = new_ieee.get_source_files("*test_fphdl.vhdl")
    test_fphdl16 = new_ieee.get_source_files("*test_fphdl16.vhdl")
    test_fphdl64 = new_ieee.get_source_files("*test_fphdl64.vhdl")
    test_fphdl128 = new_ieee.get_source_files("*test_fphdl128.vhdl")
    test_fphdlbase = new_ieee.get_source_files("*test_fphdlbase.vhdl")
    test_fpfixed = new_ieee.get_source_files("*test_fpfixed.vhdl")
    test_fp32 = new_ieee.get_source_files("*test_fp32.vhdl")
    fixed_noround_pkg = new_ieee.get_source_files("*fixed_noround_pkg.vhdl")
    float_roundneg_pkg = new_ieee.get_source_files("*float_roundneg_pkg.vhdl")
    float_noround_pkg = new_ieee.get_source_files("*float_noround_pkg.vhdl")

    if not args.vendor_verification:
        fixed_pkg = new_ieee.get_source_files("*fixed_pkg.vhdl")
        float_pkg = new_ieee.get_source_files("*float_pkg.vhdl")
        fixed_generic_pkg_body = new_ieee.get_source_files("*fixed_generic_pkg-body.vhdl")
        float_generic_pkg = new_ieee.get_source_files("*float_generic_pkg.vhdl")
        float_generic_pkg_body = new_ieee.get_source_files("*float_generic_pkg-body.vhdl")

    if not args.vendor_verification:
        float_pkg.add_dependency_on(fixed_pkg)
        float_pkg.add_dependency_on(float_generic_pkg_body)
        fixed_pkg.add_dependency_on(fixed_generic_pkg_body)
        float_generic_pkg.add_dependency_on(fixed_pkg)
        test_fixed.add_dependency_on(fixed_pkg)
        test_fixed2.add_dependency_on(fixed_pkg)
        test_fixed3.add_dependency_on(fixed_pkg)
        test_fphdlbase.add_dependency_on(fixed_pkg)
        test_fpfixed.add_dependency_on(fixed_pkg)
        test_fp32.add_dependency_on(fixed_pkg)
        test_fphdl64.add_dependency_on(float_pkg)
        test_fphdl128.add_dependency_on(float_pkg)
        test_fphdlbase.add_dependency_on(float_pkg)
        test_fpfixed.add_dependency_on(float_pkg)
        test_fp32.add_dependency_on(float_pkg)
        float_roundneg_pkg.add_dependency_on(float_generic_pkg_body)
        float_noround_pkg.add_dependency_on(float_generic_pkg_body)
        fixed_noround_pkg.add_dependency_on(fixed_generic_pkg_body)

    test_fphdl.add_dependency_on(float_roundneg_pkg)
    test_fphdl16.add_dependency_on(float_noround_pkg)
    test_fixed_nr.add_dependency_on(fixed_noround_pkg)

    prj.set_sim_option("vhdl_assert_stop_level", "warning")
    for testbench in new_ieee.get_test_benches():
        for test_case in testbench.get_tests():
            if test_case.name.startswith("Expected to warn"):
                levels = ["warning", "error"]
            elif test_case.name.startswith("Expected to fail"):
                levels = ["error", "failure"]
            else:
                levels = []

            for level in levels:
                sim_options = dict(vhdl_assert_stop_level=level)
                test_case.add_config(name="stop@%s" % level, sim_options=sim_options)

    return prj

def check_report(report_file):
    """ Report mismatch between test case status and expectation."""

    def expected_to_fail(test_case_name):
        if "Expected to fail" in test_case_name:
            return ("stop@warning" in test_case_name) or ("stop@error" in test_case_name)
        elif "Expected to warn" in test_case_name:
            return ("stop@warning" in test_case_name)
        else:
            return False

    report = ElementTree.parse(report_file)
    root = report.getroot()
    mismatch = False
    for n, test in enumerate(root.iter("testcase"), 1):
        full_name = test.attrib["classname"] + "." + test.attrib["name"]
        if test.find("skipped") is not None:
            pass
        elif test.find("failure") is not None:
            if not expected_to_fail(full_name):
                mismatch = True
                print("Wrong status for %s. Expected it to pass." % full_name)
        else:
            if expected_to_fail(full_name):
                mismatch = True
                print("Wrong status for %s. Expected it to fail." % full_name)

    if mismatch:
        raise AssertionError("Test case status mismatch")
    else:
        print("%d test cases passed and failed as expected." % n)

root = Path(__file__).parent
args = get_args(root)
prj = create_project(root, args)

try:
    prj.main()
except:
    pass

xunit_xml_path = Path(args.xunit_xml)
if xunit_xml_path.exists():
    check_report(args.xunit_xml)
