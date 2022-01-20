
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATtiny13A
;Program type           : Application
;Clock frequency        : 1.200000 MHz
;Memory model           : Tiny
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 16 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Automatic register allocation for global variables: On
;Smart register allocation: Off

	#define _MODEL_TINY_

	#pragma AVRPART ADMIN PART_NAME ATtiny13A
	#pragma AVRPART MEMORY PROG_FLASH 1024
	#pragma AVRPART MEMORY EEPROM 64
	#pragma AVRPART MEMORY INT_SRAM SIZE 64
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E

	.EQU WDTCR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x009F
	.EQU __DSTACK_SIZE=0x0010
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOV  R30,R0
	MOV  R31,R1
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __GETB1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOV  R30,R0
	MOV  R31,R1
	.ENDM

	.MACRO __GETB2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOV  R26,R0
	MOV  R27,R1
	.ENDM

	.MACRO __GETBRSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _brightness=R4
	.DEF _brightness_prev=R5
	.DEF _blink_max_bright=R6
	.DEF _frequency=R7
	.DEF _frequency_prev=R8
	.DEF _butt_timer=R9
	.DEF _butt_timer_msb=R10
	.DEF _pause_timer=R11
	.DEF _pause_timer_msb=R12
	.DEF _blink_timer=R13
	.DEF _blink_timer_msb=R14

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP _timer2_ovf_int
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,__CLEAR_SRAM_SIZE
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x70

	.CSEG
;/*
; * garland.c
; *
; * Created: 12-Dec-21 17:41:43
; * Author: JaizzY
; */
;
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x18
	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_powerdown=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <bits_macros.h>
;#include <stdint.h>
;#include <eeprom.h>
;
;#define BASIC_BRIGHT 100
;#define MAX_BRIGHT 240
;#define MIN_BRIGHT 1
;#define HALF_BRIGHT MAX_BRIGHT/2
;#define BRIGHT_RANGE (MAX_BRIGHT - MIN_BRIGHT)
;
;#define BASIC_FREQ 20
;#define MAX_FREQ 255
;#define MIN_FREQ 2
;#define FREQ_RANGE (MAX_FREQ - MIN_FREQ)
;
;#define MAX_PAUSE 7000
;#define MIN_PAUSE 100
;#define PAUSE_RANGE (MAX_PAUSE - MIN_PAUSE)
;
;#define RANGE_RATE_FQ_PS (PAUSE_RANGE/FREQ_RANGE)
;#define RANGE_RATE_BR_PS (PAUSE_RANGE/BRIGHT_RANGE)
;
;#define BUTTON 3
;
;#define CHANGE_RATE 75
;#define BUTT_TMIER_TOP 2500
;#define EEPROM_TIMER_TOP 30000
;#define TRUE 1
;#define FALSE 0
;
;#define PWM_STOP 0b00000011
;#define PWM_ON 0b00100011 //OC0B					//0b00100011 - OC0B, 0b10000011 - OC0A
;
;uint8_t brightness, brightness_prev, blink_max_bright;
;uint8_t frequency, frequency_prev;
;uint8_t EEMEM eeprom_bright;
;uint8_t EEMEM eeprom_freq;
;//uint8_t EEMEM eeprom_blink;
;uint16_t butt_timer;
;uint16_t pause_timer;
;uint16_t blink_timer;
;uint16_t eeprom_timer;
;uint16_t change_timer;
;uint16_t pause_top;
;uint16_t br_to_ps_range;
;
;_Bool bright_increase = FALSE;
;_Bool freq_increase = FALSE;
;_Bool butt_pressed = FALSE;
;_Bool blink = FALSE;
;_Bool LED_change = FALSE;
;_Bool save_to_eeprom = FALSE;
;_Bool pause = FALSE;
;
;interrupt [TIM0_OVF] void timer2_ovf_int (void){
; 0000 0040 interrupt [4] void timer2_ovf_int (void){

	.CSEG
_timer2_ovf_int:
; .FSTART _timer2_ovf_int
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0041 	if (butt_pressed){
	RCALL SUBOPT_0x0
	BREQ _0x3
; 0000 0042 		if (butt_timer < BUTT_TMIER_TOP) butt_timer++;
	LDI  R30,LOW(2500)
	LDI  R31,HIGH(2500)
	CP   R9,R30
	CPC  R10,R31
	BRSH _0x4
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 9,10,30,31
; 0000 0043 	}
_0x4:
; 0000 0044 
; 0000 0045 	if (blink){
_0x3:
	RCALL SUBOPT_0x1
	BREQ _0x5
; 0000 0046 		if (blink_timer < frequency) blink_timer++;
	RCALL SUBOPT_0x2
	BRSH _0x6
	__GETW1R 13,14
	ADIW R30,1
	__PUTW1R 13,14
	SBIW R30,1
; 0000 0047 	}
_0x6:
; 0000 0048 
; 0000 0049 	if (LED_change){
_0x5:
	LDS  R30,_LED_change
	CPI  R30,0
	BREQ _0x7
; 0000 004A 		if (change_timer < CHANGE_RATE) change_timer++;
	RCALL SUBOPT_0x3
	BRSH _0x8
	LDI  R26,LOW(_change_timer)
	RCALL SUBOPT_0x4
; 0000 004B 	}
_0x8:
; 0000 004C 
; 0000 004D 	if (save_to_eeprom){
_0x7:
	LDS  R30,_save_to_eeprom
	CPI  R30,0
	BREQ _0x9
; 0000 004E 		if (eeprom_timer < EEPROM_TIMER_TOP) eeprom_timer++;
	RCALL SUBOPT_0x5
	BRSH _0xA
	LDI  R26,LOW(_eeprom_timer)
	RCALL SUBOPT_0x4
; 0000 004F 	}
_0xA:
; 0000 0050 
; 0000 0051 	if (pause){
_0x9:
	LDS  R30,_pause
	CPI  R30,0
	BREQ _0xB
; 0000 0052 		if (pause_timer < pause_top) pause_timer++;
	RCALL SUBOPT_0x6
	CP   R11,R30
	CPC  R12,R31
	BRSH _0xC
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 11,12,30,31
; 0000 0053 	}
_0xC:
; 0000 0054 }
_0xB:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;void pause_calc (void){
; 0000 0056 void pause_calc (void){
_pause_calc:
; .FSTART _pause_calc
; 0000 0057 	if (brightness_prev < HALF_BRIGHT) {
	LDI  R30,LOW(120)
	CP   R5,R30
	BRSH _0xD
; 0000 0058 		pause_top = ((((frequency - MIN_FREQ) * RANGE_RATE_FQ_PS) + MIN_PAUSE) + br_to_ps_range) >> 1;
	RCALL SUBOPT_0x7
	LDS  R26,_br_to_ps_range
	LDS  R27,_br_to_ps_range+1
	ADD  R26,R30
	ADC  R27,R31
	MOV  R30,R26
	MOV  R31,R27
	LSR  R31
	ROR  R30
	RJMP _0x40
; 0000 0059 	}
; 0000 005A 	else pause_top = (((frequency - MIN_FREQ) * RANGE_RATE_FQ_PS) + MIN_PAUSE);
_0xD:
	RCALL SUBOPT_0x7
_0x40:
	STS  _pause_top,R30
	STS  _pause_top+1,R31
; 0000 005B }
	RET
; .FEND
;
;void main(void)
; 0000 005E {
_main:
; .FSTART _main
; 0000 005F 	DDRB = 0b00000011;														//B0 - out, PWM channel A; button pin B3
	LDI  R30,LOW(3)
	OUT  0x17,R30
; 0000 0060 	PORTB = 0b00001000;														//butt pin pull-up
	LDI  R30,LOW(8)
	OUT  0x18,R30
; 0000 0061 
; 0000 0062 	brightness = eeprom_read_byte(&eeprom_bright);							//rewriting from EEPROM to brightness
	LDI  R26,LOW(_eeprom_bright)
	LDI  R27,HIGH(_eeprom_bright)
	RCALL __EEPROMRDB
	MOV  R4,R30
; 0000 0063 	frequency = eeprom_read_byte(&eeprom_freq);
	LDI  R26,LOW(_eeprom_freq)
	LDI  R27,HIGH(_eeprom_freq)
	RCALL __EEPROMRDB
	MOV  R7,R30
; 0000 0064 //	blink = eeprom_read_byte(&eeprom_blink);
; 0000 0065 
; 0000 0066 	if (brightness > MAX_BRIGHT) {											//if eeprom is reset rewriting default brightness from EEPROM to 'brightness'
	LDI  R30,LOW(240)
	CP   R30,R4
	BRSH _0xF
; 0000 0067 		brightness = BASIC_BRIGHT;
	LDI  R30,LOW(100)
	MOV  R4,R30
; 0000 0068 		eeprom_write_byte(&eeprom_bright, brightness);
	RCALL SUBOPT_0x8
; 0000 0069 	}
; 0000 006A 
; 0000 006B 	brightness_prev = brightness;
_0xF:
	MOV  R5,R4
; 0000 006C 	frequency_prev = frequency;
	MOV  R8,R7
; 0000 006D //	brightness_prev = brightness;
; 0000 006E 
; 0000 006F 	if (brightness >= MAX_BRIGHT - 50) bright_increase = TRUE;
	LDI  R30,LOW(190)
	CP   R4,R30
	BRLO _0x10
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x9
; 0000 0070 	if (brightness <= MIN_BRIGHT + 50) bright_increase = FALSE;
_0x10:
	LDI  R30,LOW(51)
	CP   R30,R4
	BRLO _0x11
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x9
; 0000 0071 
; 0000 0072 	if (frequency >= MAX_FREQ - 50) freq_increase = TRUE;
_0x11:
	LDI  R30,LOW(205)
	CP   R7,R30
	BRLO _0x12
	LDI  R30,LOW(1)
	STS  _freq_increase,R30
; 0000 0073 	if (frequency <= MIN_FREQ + 50) freq_increase = FALSE;
_0x12:
	LDI  R30,LOW(52)
	CP   R30,R7
	BRLO _0x13
	LDI  R30,LOW(0)
	STS  _freq_increase,R30
; 0000 0074 
; 0000 0075 	br_to_ps_range = (((brightness_prev - MIN_BRIGHT) * RANGE_RATE_BR_PS) + MIN_PAUSE);
_0x13:
	MOV  R30,R5
	LDI  R31,0
	SBIW R30,1
	LDI  R26,LOW(28)
	LDI  R27,HIGH(28)
	RCALL __MULW12
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	STS  _br_to_ps_range,R30
	STS  _br_to_ps_range+1,R31
; 0000 0076 	pause_calc();
	RCALL _pause_calc
; 0000 0077 
; 0000 0078 	while (BitIsClear(PINB, BUTTON)) blink = TRUE;
_0x14:
	SBIC 0x16,3
	RJMP _0x16
	LDI  R30,LOW(1)
	STS  _blink,R30
	RJMP _0x14
_0x16:
; 0000 007A TCCR0A = 0b00100011 ;
	RCALL SUBOPT_0xA
; 0000 007B 	TCCR0B = 0b00000001;
	LDI  R30,LOW(1)
	OUT  0x33,R30
; 0000 007C 	TIMSK0 = 0b00000010;													//timer 0 overflow interrupt enable
	LDI  R30,LOW(2)
	OUT  0x39,R30
; 0000 007D 
; 0000 007E 	OCR0B = brightness;
	OUT  0x29,R4
; 0000 007F 
; 0000 0080 	#asm("sei");
	sei
; 0000 0081 
; 0000 0082 	while (1)
_0x17:
; 0000 0083 	{
; 0000 0084 		if (BitIsClear(PINB, BUTTON)) butt_pressed = TRUE;
	SBIC 0x16,3
	RJMP _0x1A
	LDI  R30,LOW(1)
	STS  _butt_pressed,R30
; 0000 0085 		else if (butt_pressed){
	RJMP _0x1B
_0x1A:
	RCALL SUBOPT_0x0
	BREQ _0x1C
; 0000 0086 			butt_pressed = FALSE;
	LDI  R30,LOW(0)
	STS  _butt_pressed,R30
; 0000 0087 			butt_timer = 0;
	CLR  R9
	CLR  R10
; 0000 0088 			LED_change = FALSE;
	STS  _LED_change,R30
; 0000 0089 			if ((brightness_prev != brightness) || (frequency_prev != frequency)) save_to_eeprom = TRUE;
	CP   R4,R5
	BRNE _0x1E
	CP   R7,R8
	BREQ _0x1D
_0x1E:
	LDI  R30,LOW(1)
	STS  _save_to_eeprom,R30
; 0000 008A 		}
_0x1D:
; 0000 008B 
; 0000 008C 		if (eeprom_timer == EEPROM_TIMER_TOP) {
_0x1C:
_0x1B:
	RCALL SUBOPT_0x5
	BRNE _0x20
; 0000 008D 			if (blink) {
	RCALL SUBOPT_0x1
	BREQ _0x21
; 0000 008E 				eeprom_write_byte(&eeprom_freq, frequency);
	MOV  R30,R7
	LDI  R26,LOW(_eeprom_freq)
	LDI  R27,HIGH(_eeprom_freq)
	RCALL __EEPROMWRB
; 0000 008F 				frequency_prev = frequency;
	MOV  R8,R7
; 0000 0090 			}
; 0000 0091 			else {
	RJMP _0x22
_0x21:
; 0000 0092 				eeprom_write_byte(&eeprom_bright, brightness);
	RCALL SUBOPT_0x8
; 0000 0093 				brightness_prev = brightness;
	MOV  R5,R4
; 0000 0094 			}
_0x22:
; 0000 0095 
; 0000 0096 			eeprom_timer = 0;
	RCALL SUBOPT_0xB
; 0000 0097 			save_to_eeprom = FALSE;
; 0000 0098 			TCCR0A = PWM_STOP;
; 0000 0099 			delay_ms(20);
	LDI  R26,LOW(20)
	RCALL SUBOPT_0xC
; 0000 009A 			TCCR0A = PWM_ON;
; 0000 009B 		}
; 0000 009C 
; 0000 009D 		if (butt_pressed){
_0x20:
	RCALL SUBOPT_0x0
	BREQ _0x23
; 0000 009E 			if (butt_timer == BUTT_TMIER_TOP){
	LDI  R30,LOW(2500)
	LDI  R31,HIGH(2500)
	CP   R30,R9
	CPC  R31,R10
	BRNE _0x24
; 0000 009F 				if (!blink) bright_increase = !bright_increase;
	RCALL SUBOPT_0x1
	BRNE _0x25
	LDS  R30,_bright_increase
	RCALL __LNEGB1
	RCALL SUBOPT_0x9
; 0000 00A0 				else freq_increase = !freq_increase;
	RJMP _0x26
_0x25:
	LDS  R30,_freq_increase
	RCALL __LNEGB1
	STS  _freq_increase,R30
; 0000 00A1 
; 0000 00A2 				LED_change = TRUE;
_0x26:
	LDI  R30,LOW(1)
	STS  _LED_change,R30
; 0000 00A3 				butt_timer++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 9,10,30,31
; 0000 00A4 				eeprom_timer = 0;
	RCALL SUBOPT_0xB
; 0000 00A5 				save_to_eeprom = FALSE;
; 0000 00A6 				TCCR0A = PWM_STOP;
; 0000 00A7 				delay_ms(10);
	LDI  R26,LOW(10)
	RCALL SUBOPT_0xC
; 0000 00A8 				TCCR0A = PWM_ON;
; 0000 00A9 			}
; 0000 00AA 		}
_0x24:
; 0000 00AB 
; 0000 00AC 		if (!blink){
_0x23:
	RCALL SUBOPT_0x1
	BRNE _0x27
; 0000 00AD 			if (change_timer >= CHANGE_RATE){
	RCALL SUBOPT_0x3
	BRLO _0x28
; 0000 00AE 				if (bright_increase == TRUE){
	LDS  R26,_bright_increase
	CPI  R26,LOW(0x1)
	BRNE _0x29
; 0000 00AF 					if (brightness < MAX_BRIGHT) brightness++;
	LDI  R30,LOW(240)
	CP   R4,R30
	BRSH _0x2A
	INC  R4
; 0000 00B0 					else {
	RJMP _0x2B
_0x2A:
; 0000 00B1 						TCCR0A = PWM_STOP;
	RCALL SUBOPT_0xD
; 0000 00B2 						delay_ms(10);
	LDI  R26,LOW(10)
	RCALL SUBOPT_0xC
; 0000 00B3 						TCCR0A = PWM_ON;
; 0000 00B4 					}
_0x2B:
; 0000 00B5 				}
; 0000 00B6 				else{
	RJMP _0x2C
_0x29:
; 0000 00B7 					if (brightness > MIN_BRIGHT) brightness--;
	LDI  R30,LOW(1)
	CP   R30,R4
	BRSH _0x2D
	DEC  R4
; 0000 00B8 					else {
	RJMP _0x2E
_0x2D:
; 0000 00B9 						TCCR0A = PWM_STOP;
	RCALL SUBOPT_0xD
; 0000 00BA 						delay_ms(30);
	LDI  R26,LOW(30)
	RCALL SUBOPT_0xC
; 0000 00BB 						TCCR0A = PWM_ON;
; 0000 00BC 					}
_0x2E:
; 0000 00BD 				}
_0x2C:
; 0000 00BE 				OCR0B = brightness;
	OUT  0x29,R4
; 0000 00BF 				change_timer = 0;
	RCALL SUBOPT_0xE
; 0000 00C0 			}
; 0000 00C1 		}
_0x28:
; 0000 00C2 		else{
	RJMP _0x2F
_0x27:
; 0000 00C3 			if (blink_timer >= frequency){
	RCALL SUBOPT_0x2
	BRLO _0x30
; 0000 00C4 				if (bright_increase == TRUE){
	LDS  R26,_bright_increase
	CPI  R26,LOW(0x1)
	BRNE _0x31
; 0000 00C5 					if (brightness < brightness_prev) brightness++;
	CP   R4,R5
	BRSH _0x32
	INC  R4
; 0000 00C6 					else {
	RJMP _0x33
_0x32:
; 0000 00C7 						pause = TRUE;
	RCALL SUBOPT_0xF
; 0000 00C8 						if (pause_timer >= pause_top>>1){
	LSR  R31
	ROR  R30
	CP   R11,R30
	CPC  R12,R31
	BRLO _0x34
; 0000 00C9 							{
; 0000 00CA 								bright_increase = FALSE;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x10
; 0000 00CB 								pause_timer = 0;
; 0000 00CC 								pause = FALSE;
; 0000 00CD 							}
; 0000 00CE 						}
; 0000 00CF 					}
_0x34:
_0x33:
; 0000 00D0 				}
; 0000 00D1 				else{
	RJMP _0x35
_0x31:
; 0000 00D2 					if (brightness > 0) brightness--;
	LDI  R30,LOW(0)
	CP   R30,R4
	BRSH _0x36
	DEC  R4
; 0000 00D3 					else {
	RJMP _0x37
_0x36:
; 0000 00D4 						TCCR0A = PWM_STOP;
	RCALL SUBOPT_0xD
; 0000 00D5 						pause = TRUE;
	RCALL SUBOPT_0xF
; 0000 00D6 						if (pause_timer >= pause_top){
	CP   R11,R30
	CPC  R12,R31
	BRLO _0x38
; 0000 00D7 							{
; 0000 00D8 								TCCR0A = PWM_ON;
	RCALL SUBOPT_0xA
; 0000 00D9 								bright_increase = TRUE;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x10
; 0000 00DA 								pause_timer = 0;
; 0000 00DB 								pause = FALSE;
; 0000 00DC 							}
; 0000 00DD 						}
; 0000 00DE 					}
_0x38:
_0x37:
; 0000 00DF 				}
_0x35:
; 0000 00E0 				blink_timer = 0;
	CLR  R13
	CLR  R14
; 0000 00E1 				OCR0B = brightness;
	OUT  0x29,R4
; 0000 00E2 			}
; 0000 00E3 
; 0000 00E4 			if (change_timer >= CHANGE_RATE){
_0x30:
	RCALL SUBOPT_0x3
	BRLO _0x39
; 0000 00E5 				if (freq_increase == TRUE){
	LDS  R26,_freq_increase
	CPI  R26,LOW(0x1)
	BRNE _0x3A
; 0000 00E6 					if (frequency < MAX_FREQ) frequency++;
	LDI  R30,LOW(255)
	CP   R7,R30
	BRSH _0x3B
	INC  R7
; 0000 00E7 					else{
	RJMP _0x3C
_0x3B:
; 0000 00E8 						TCCR0A = PWM_STOP;
	RCALL SUBOPT_0xD
; 0000 00E9 						delay_ms(30);
	LDI  R26,LOW(30)
	RCALL SUBOPT_0xC
; 0000 00EA 						TCCR0A = PWM_ON;
; 0000 00EB 						}
_0x3C:
; 0000 00EC 					pause_calc();
	RJMP _0x41
; 0000 00ED 				}
; 0000 00EE 				else{
_0x3A:
; 0000 00EF 					if (frequency > MIN_FREQ) frequency--;
	LDI  R30,LOW(2)
	CP   R30,R7
	BRSH _0x3E
	DEC  R7
; 0000 00F0 					pause_calc();
_0x3E:
_0x41:
	RCALL _pause_calc
; 0000 00F1 				}
; 0000 00F2 			 change_timer = 0;
	RCALL SUBOPT_0xE
; 0000 00F3 			}
; 0000 00F4 		}
_0x39:
_0x2F:
; 0000 00F5 	}
	RJMP _0x17
; 0000 00F6 }
_0x3F:
	RJMP _0x3F
; .FEND

	.CSEG

	.ESEG
_eeprom_bright:
	.BYTE 0x1
_eeprom_freq:
	.BYTE 0x1

	.DSEG
_eeprom_timer:
	.BYTE 0x2
_change_timer:
	.BYTE 0x2
_pause_top:
	.BYTE 0x2
_br_to_ps_range:
	.BYTE 0x2
_bright_increase:
	.BYTE 0x1
_freq_increase:
	.BYTE 0x1
_butt_pressed:
	.BYTE 0x1
_blink:
	.BYTE 0x1
_LED_change:
	.BYTE 0x1
_save_to_eeprom:
	.BYTE 0x1
_pause:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	LDS  R30,_butt_pressed
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	LDS  R30,_blink
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	MOV  R30,R7
	__GETW2R 13,14
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x3:
	LDS  R26,_change_timer
	LDS  R27,_change_timer+1
	CPI  R26,LOW(0x4B)
	LDI  R30,HIGH(0x4B)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5:
	LDS  R26,_eeprom_timer
	LDS  R27,_eeprom_timer+1
	CPI  R26,LOW(0x7530)
	LDI  R30,HIGH(0x7530)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6:
	LDS  R30,_pause_top
	LDS  R31,_pause_top+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	MOV  R30,R7
	LDI  R31,0
	SBIW R30,2
	LDI  R26,LOW(27)
	LDI  R27,HIGH(27)
	RCALL __MULW12
	SUBI R30,LOW(-100)
	SBCI R31,HIGH(-100)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	MOV  R30,R4
	LDI  R26,LOW(_eeprom_bright)
	LDI  R27,HIGH(_eeprom_bright)
	RCALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	STS  _bright_increase,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(35)
	OUT  0x2F,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(0)
	STS  _eeprom_timer,R30
	STS  _eeprom_timer+1,R30
	STS  _save_to_eeprom,R30
	LDI  R30,LOW(3)
	OUT  0x2F,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xC:
	LDI  R27,0
	RCALL _delay_ms
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(3)
	OUT  0x2F,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(0)
	STS  _change_timer,R30
	STS  _change_timer+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(1)
	STS  _pause,R30
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	RCALL SUBOPT_0x9
	CLR  R11
	CLR  R12
	LDI  R30,LOW(0)
	STS  _pause,R30
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x12C
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LNEGB1:
	TST  R30
	LDI  R30,1
	BREQ __LNEGB1F
	CLR  R30
__LNEGB1F:
	RET

__MULW12U:
	MOV  R0,R26
	MOV  R1,R27
	LDI  R24,17
	CLR  R26
	SUB  R27,R27
	RJMP __MULW12U1
__MULW12U3:
	BRCC __MULW12U2
	ADD  R26,R0
	ADC  R27,R1
__MULW12U2:
	LSR  R27
	ROR  R26
__MULW12U1:
	ROR  R31
	ROR  R30
	DEC  R24
	BRNE __MULW12U3
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

;END OF CODE MARKER
__END_OF_CODE:
