ENTRY(Reset_Handler)

MEMORY
{
	FLASH(rx) :ORIGIN =0x08000000,LENGTH =1024K
	SRAM1(rwx) :ORIGIN =0x20000000,LENGTH =112K
	SRAM2(rwx) :ORIGIN =0x2001C000,LENGTH =16k
}

/*
	By convention, these sections are named:
	.text: code and constants
	.bss: for uninitialised data
	.stack: for stack
	.data: for initialised data
	
	Check this out for other conventions: https://refspecs.linuxbase.org/elf/elf.pdf
*/

SECTIONS
{
	.text :
	{
		*(.isr_vector)		
	
		/*
			Merge all of the .text sections of all the .o files. * is a wildcard
			(this below is referring to all .text sections in all object files)
		*/
		
		*(.text)
		*(.rodata)
		
		/*
			This is the location counter. It tracks the current offset into a given memory region.
			In the statement below, we are creating a symbol to pass into the startup script with the
			address at the end of *(.rodata).
		*/
		
		_etext = .;
	}> FLASH
	
	.data :
	{
		_sdata = .;
		*(.data)
		_edata = .;
	}> SRAM1 AT > FLASH
	
	/*
	}> vma AT > lma
	VMA: Virtual Memory Address. This is the address during execution.
	LMA: Load Memory Address. This is the address "at rest".
	If VMA and LMA are the same, just use: }> vma.
	*/
	
	.bss :
	{
		_sbss = .;
		*(.bss)
		_ebss = .;
	}> SRAM1
}
