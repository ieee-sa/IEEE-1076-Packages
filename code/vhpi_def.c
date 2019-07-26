/* --------------------------------------------------------------------
/*
/* Copyright 2019 IEEE P1076 WG Authors
/* 
/* See the LICENSE file distributed with this work for copyright and
/* licensing information and the AUTHORS file.
/* 
/* This file to you under the Apache License, Version 2.0 (the "License").
/* You may obtain a copy of the License at
/* 
/*     http://www.apache.org/licenses/LICENSE-2.0
/* 
/* Unless required by applicable law or agreed to in writing, software
/* distributed under the License is distributed on an "AS IS" BASIS,
/* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
/* implied.  See the License for the specific language governing
/* permissions and limitations under the License.
/* 
/*   Title     :  vhpi_defs.c
/*             :
/*   Developers:  IEEE P1076 Working Group, VHPI Task Force
/*             :
/*   Purpose   :  This file contains utilities source code as examples
/*             :  of possible implementations.
/*             :
/* --------------------------------------------------------------------
/* modification history :
/* --------------------------------------------------------------------
/* $Revision: 1219 $
/* $Date: 2008-04-10 16:40:28 +0930 (Thu, 10 Apr 2008) $
/* --------------------------------------------------------------------
 */
  

/* utilities to print VHDL strings */

int vhpi_is_printable( unsigned char ch ) {

if (ch < 32) return 0;
if (ch < 127) return 1;
if (ch == 127) return 0;
if (ch < 160) return 0;
return 1;
}


static const char* VHPICharCodes[256] = {
  "NUL", "SOH", "STX", "ETX", "EOT", "ENQ", "ACK",  "BEL" ,
  "BS",  "HT",  "LF",  "VT",  "FF",  "CR",  "SO" ,  "SI",
  "DLE", "DC1", "DC2", "DC3", "DC4", "NAK", "SYN" , "ETB",
  "CAN", "EM",  "SUB", "ESC", "FSP", "GSP", "RSP" , "USP",
  " ", "!", "\"", "#", "$", "%", "&", "", 
  "(", ")", "*", "+", ", ", "-", ".", "/", 
  "0", "1", "2", "3", "4", "5", "6", "7", 
  "8", "9", ":", ";", "<", "=", ">", "?", 
  "@", "A", "B", "C", "D", "E", "F", "G", 
  "H", "I", "J", "K", "L", "M", "N", "O", 
  "P", "Q", "R", "S", "T", "U", "V", "W", 
  "X", "Y", "Z", "[", "\\", "]", "^", "_", 
  "`", "a", "b", "c", "d", "e", "f", "g", 
  "h", "i", "j", "k", "l", "m", "n", "o", 
  "p", "q", "r", "s", "t", "u", "v", "w", 
  "x", "y", "z", "{", "|", "}", "~", "DEL",
  "C128", "C129", "C130", "C131", "C132", "C133", "C134", "C135",
  "C136", "C137", "C138", "C139", "C140", "C141", "C142", "C143",
  "C144", "C145", "C146", "C147", "C148", "C149", "C150", "C151",
  "C152", "C153", "C154", "C155", "C156", "C157", "C158", "C159",
  " ", "¡", "¢", "£", "¤", "¥", "¦", "§", 
  "¨", "©", "ª", "«", "¬", "­", "®", "¯", 
  "°", "±", "²", "³", "´", "µ", "¶", "·", 
  "¸", "¹", "º", "»", "¼", "½", "¾", "¿", 
  "À", "Á", "Â", "Ã", "Ä", "Å", "Æ", "Ç", 
  "È", "É", "Ê", "Ë", "Ì", "Í", "Î", "Ï", 
  "Ð", "Ñ", "Ò", "Ó", "Ô", "Õ", "Ö", "×", 
  "Ø", "Ù", "Ú", "Û", "Ü", "Ý", "Þ", "ß", 
  "à", "á", "â", "ã", "ä", "å", "æ", "ç", 
  "è", "é", "ê", "ë", "ì", "í", "î", "ï", 
  "ð", "ñ", "ò", "ó", "ô", "õ", "ö", "÷", 
  "ø", "ù", "ú", "û", "ü", "ý", "þ", "ÿ" };

#define VHPI_GET_PRINTABLE_STRINGCODE( ch ) VHPICharCodes[unsigned char ch]
