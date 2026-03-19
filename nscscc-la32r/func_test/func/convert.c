#include <stdio.h>
#include <stdlib.h>
void binary_out(FILE* out,unsigned char* mem)
{
    char tmp;
    int  i,j;
    unsigned char num[8];
    num[0] = 1;
    num[1] = 2;
    num[2] = 4;
    num[3] = 8;
    num[4] = 16;
    num[5] = 32;
    num[6] = 64;
    num[7] = 128;
    for(i=3;i>=0;i--)
    {
        for(j=7;j>=0;j--)
        {
            if( (mem[i] & num[j] ) != 0)
                tmp = '1';
            else
                tmp = '0';
            fprintf(out,"%c",tmp);
        }
    }
    fprintf(out,"\n");
    return;
}

#include <string.h>
#include <stdbool.h>
#include <ctype.h>
#include "include/mycpu_inst.h"
void scan_bin_str(char *fname);


int main(void)
{
	FILE *in;
	FILE *out;

	int i,j,k;
	unsigned char mem[32];

    in = fopen("main.bin", "rb");
    out = fopen("inst_ram.coe","w");

	fprintf(out, "memory_initialization_radix = 16;\n");
	fprintf(out, "memory_initialization_vector =\n");
	while(!feof(in)) {
	    if(fread(mem,1,4,in)!=4) {
	        fprintf(out, "%02x%02x%02x%02x\n", mem[3], mem[2],	mem[1], mem[0]);
		break;
	     }
	    fprintf(out, "%02x%02x%02x%02x\n", mem[3], mem[2], mem[1],mem[0]);
        }
	fclose(in);
	fclose(out);

    in = fopen("main.data", "rb");
    out = fopen("data_ram.coe","w");

	fprintf(out, "memory_initialization_radix = 16;\n");
	fprintf(out, "memory_initialization_vector =\n");
	while(!feof(in)) {
	    if(fread(mem,1,4,in)!=4) {
	        fprintf(out, "%02x%02x%02x%02x\n", mem[3], mem[2],	mem[1], mem[0]);
		break;
	     }
	    fprintf(out, "%02x%02x%02x%02x\n", mem[3], mem[2], mem[1],mem[0]);
        }
	fclose(in);
	fclose(out);

    in = fopen("main.data", "rb");
    out = fopen("data_ram.mif","w");

	while(!feof(in)) {
	    if(fread(mem,1,4,in)!=4) {
            binary_out(out,mem);
		break;
	     }
            binary_out(out,mem);
        }
	fclose(in);
	fclose(out);

    in = fopen("main.bin", "rb");
    out = fopen("inst_ram.mif","w");

	while(!feof(in)) {
	    if(fread(mem,1,4,in)!=4) {
            binary_out(out,mem);
		break;
	     }
            binary_out(out,mem);
        }
	fclose(in);
	fclose(out);

    in  = fopen("main.bin","rb");
    out = fopen("rom.vlog","w");
    fprintf(out,"@1c000000\n");
    while(!feof(in)) {
        if (fread(mem,1,1,in) != 1) {
            fprintf(out,"%02x\n", mem[0]);
            break;
        } 
        fprintf(out,"%02x\n", mem[0]);
    }
    fclose(in);
    fclose(out);

    scan_bin_str("inst_ram.mif");

    return 0;
}



char* get_slice(const char* bin_str, int i, int j)
{
    if (!bin_str || strlen(bin_str) != 32) return NULL;
    if (i < j || i > 31 || j < 0) return NULL;

    int start_idx = 31 - i;
    int end_idx   = 31 - j;
    int len = end_idx - start_idx + 1;

    char* slice = malloc(len + 1);
    if (!slice) return NULL;

    strncpy(slice, bin_str + start_idx, len);
    slice[len] = '\0';

    return slice;
}

bool val_cmp(const char* bin_str, unsigned long hex_val)
{
    if (!bin_str) return false;
    if (bin_str[0] == '\0') bin_str = "0";

    char* endptr;
    unsigned long bin_val = strtoul(bin_str, &endptr, 2);
    if (*endptr != '\0') return false;

    return bin_val == hex_val;
}

char* inst_name(const char* inst_str)
{
    char* opcode_31_25 = get_slice(inst_str, 31, 25);
    char* opcode_31_15 = get_slice(inst_str, 31, 15);
    char* opcode_31_22 = get_slice(inst_str, 31, 22);
    char* opcode_31_26 = get_slice(inst_str, 31, 26);

    bool LU12I_W   = val_cmp(opcode_31_25, 0x0A   );
    bool ADD_W     = val_cmp(opcode_31_15, 0x00020);
    bool ADDI_W    = val_cmp(opcode_31_22, 0x00A  );
    bool SUB_W     = val_cmp(opcode_31_15, 0x00022);
    bool SLT       = val_cmp(opcode_31_15, 0x00024);
    bool SLTU      = val_cmp(opcode_31_15, 0x00025);
    bool AND       = val_cmp(opcode_31_15, 0x00029);
    bool OR        = val_cmp(opcode_31_15, 0x0002A);
    bool XOR       = val_cmp(opcode_31_15, 0x0002B);
    bool NOR       = val_cmp(opcode_31_15, 0x00028);
    bool SLLI_W    = val_cmp(opcode_31_15, 0x00081);
    bool SRLI_W    = val_cmp(opcode_31_15, 0x00089);
    bool SRAI_W    = val_cmp(opcode_31_15, 0x00091);
    bool LD_W      = val_cmp(opcode_31_22, 0x0A2  );
    bool ST_W      = val_cmp(opcode_31_22, 0x0A6  );
    bool BEQ       = val_cmp(opcode_31_26, 0x16   );
    bool BNE       = val_cmp(opcode_31_26, 0x17   );
    bool BL        = val_cmp(opcode_31_26, 0x15   );
    bool JIRL      = val_cmp(opcode_31_26, 0x13   );
    bool B         = val_cmp(opcode_31_26, 0x14   );
    bool PCADDU12I = val_cmp(opcode_31_25, 0x0E   );
    bool SLTI      = val_cmp(opcode_31_22, 0x008  );
    bool SLTUI     = val_cmp(opcode_31_22, 0x009  );
    bool ANDI      = val_cmp(opcode_31_22, 0x00D  );
    bool ORI       = val_cmp(opcode_31_22, 0x00E  );
    bool XORI      = val_cmp(opcode_31_22, 0x00F  );
    bool SLL_W     = val_cmp(opcode_31_15, 0x0002E);
    bool SRA_W     = val_cmp(opcode_31_15, 0x00030);
    bool SRL_W     = val_cmp(opcode_31_15, 0x0002F);
    bool DIV_W     = val_cmp(opcode_31_15, 0x00040);
    bool DIV_WU    = val_cmp(opcode_31_15, 0x00042);
    bool MUL_W     = val_cmp(opcode_31_15, 0x00038);
    bool MULH_W    = val_cmp(opcode_31_15, 0x00039);
    bool MULH_WU   = val_cmp(opcode_31_15, 0x0003A);
    bool MOD_W     = val_cmp(opcode_31_15, 0x00041);
    bool MOD_WU    = val_cmp(opcode_31_15, 0x00043);
    bool BLT       = val_cmp(opcode_31_26, 0x18   );
    bool BGE       = val_cmp(opcode_31_26, 0x19   );
    bool BLTU      = val_cmp(opcode_31_26, 0x1A   );
    bool BGEU      = val_cmp(opcode_31_26, 0x1B   );
    bool LD_B      = val_cmp(opcode_31_22, 0x0A0  );
    bool LD_H      = val_cmp(opcode_31_22, 0x0A1  );
    bool LD_BU     = val_cmp(opcode_31_22, 0x0A8  );
    bool LD_HU     = val_cmp(opcode_31_22, 0x0A9  );
    bool ST_B      = val_cmp(opcode_31_22, 0x0A4  );
    bool ST_H      = val_cmp(opcode_31_22, 0x0A5  );

    if (opcode_31_25) free(opcode_31_25);
    if (opcode_31_15) free(opcode_31_15);
    if (opcode_31_22) free(opcode_31_22);
    if (opcode_31_26) free(opcode_31_26);

    if (LU12I_W  ) return "LU12I.W  ";
    if (ADD_W    ) return "ADD.W    ";
    if (ADDI_W   ) return "ADDI.W   ";
    if (SUB_W    ) return "SUB.W    ";
    if (SLT      ) return "SLT      ";
    if (SLTU     ) return "SLTU     ";
    if (AND      ) return "AND      ";
    if (OR       ) return "OR       ";
    if (XOR      ) return "XOR      ";
    if (NOR      ) return "NOR      ";
    if (SLLI_W   ) return "SLLI.W   ";
    if (SRLI_W   ) return "SRLI.W   ";
    if (SRAI_W   ) return "SRAI.W   ";
    if (LD_W     ) return "LD.W     ";
    if (ST_W     ) return "ST.W     ";
    if (BEQ      ) return "BEQ      ";
    if (BNE      ) return "BNE      ";
    if (BL       ) return "BL       ";
    if (JIRL     ) return "JIRL     ";
    if (B        ) return "B        ";
    if (PCADDU12I) return "PCADDU12I";
    if (SLTI     ) return "SLTI     ";
    if (SLTUI    ) return "SLTUI    ";
    if (ANDI     ) return "ANDI     ";
    if (ORI      ) return "ORI      ";
    if (XORI     ) return "XORI     ";
    if (SLL_W    ) return "SLL.W    ";
    if (SRA_W    ) return "SRA.W    ";
    if (SRL_W    ) return "SRL.W    ";
    if (DIV_W    ) return "DIV_W    ";
    if (DIV_WU   ) return "DIV_WU   ";
    if (MUL_W    ) return "MUL_W    ";
    if (MULH_W   ) return "MULH_W   ";
    if (MULH_WU  ) return "MULH_WU  ";
    if (MOD_W    ) return "MOD_W    ";
    if (MOD_WU   ) return "MOD_WU   ";
    if (BLT      ) return "BLT      ";
    if (BGE      ) return "BGE      ";
    if (BLTU     ) return "BLTU     ";
    if (BGEU     ) return "BGEU     ";
    if (LD_B     ) return "LD.B     ";
    if (LD_H     ) return "LD.H     ";
    if (LD_BU    ) return "LD.BU    ";
    if (LD_HU    ) return "LD.HU    ";
    if (ST_B     ) return "ST.B     ";
    if (ST_H     ) return "ST.H     ";
    
    return "\0";
}

int get_test_num()
{
    return IMPL_LU12I_W   +
           IMPL_ADD_W     +
           IMPL_ADDI_W    +
           IMPL_SUB_W     +
           IMPL_SLT       +
           IMPL_SLTU      +
           IMPL_AND       +
           IMPL_OR        +
           IMPL_XOR       +
           IMPL_NOR       +
           IMPL_SLLI_W    +
           IMPL_SRLI_W    +
           IMPL_SRAI_W    +
           IMPL_LD_W      +
           IMPL_ST_W      +
           IMPL_BEQ       +
           IMPL_BNE       +
           IMPL_BL        +
           IMPL_JIRL      +
           IMPL_B         +
           IMPL_PCADDU12I +
           IMPL_SLTI      +
           IMPL_SLTUI     +
           IMPL_ANDI      +
           IMPL_ORI       +
           IMPL_XORI      +
           IMPL_SLL_W     +
           IMPL_SRA_W     +
           IMPL_SRL_W     +
           IMPL_DIV_W     +
           IMPL_DIV_WU    +
           IMPL_MUL_W     +
           IMPL_MULH_W    +
           IMPL_MULH_WU   +
           IMPL_MOD_W     +
           IMPL_MOD_WU    +
           IMPL_BLT       +
           IMPL_BGE       +
           IMPL_BLTU      +
           IMPL_BGEU      +
           IMPL_LD_B      +
           IMPL_LD_H      +
           IMPL_LD_BU     +
           IMPL_LD_HU     +
           IMPL_ST_B      +
           IMPL_ST_H      ;
}

void scan_bin_str(char *fname)
{
    FILE *fp = fopen(fname, "r");
    if (!fp)
    {
        perror("scan_bin_str: failed to open input file");
        exit(-1);
    }

    FILE *ofp = fopen("inst_list.txt", "w");
    if (!ofp)
    {
        perror("scan_bin_str: failed to create output file");
        exit(-1);
    }

    char inst[34];
    bool inst_map[46] = { false };
    char* inst_name_tbl[46] = {
        "LU12I.W  ",
        "ADD.W    ",
        "ADDI.W   ",
        "SUB.W    ",
        "SLT      ",
        "SLTU     ",
        "AND      ",
        "OR       ",
        "XOR      ",
        "NOR      ",
        "SLLI.W   ",
        "SRLI.W   ",
        "SRAI.W   ",
        "LD.W     ",
        "ST.W     ",
        "BEQ      ",
        "BNE      ",
        "BL       ",
        "JIRL     ",
        "B        ",
        "PCADDU12I",
        "SLTI     ",
        "SLTUI    ",
        "ANDI     ",
        "ORI      ",
        "XORI     ",
        "SLL.W    ",
        "SRA.W    ",
        "SRL.W    ",
        "DIV_W    ",
        "DIV_WU   ",
        "MUL_W    ",
        "MULH_W   ",
        "MULH_WU  ",
        "MOD_W    ",
        "MOD_WU   ",
        "BLT      ",
        "BGE      ",
        "BLTU     ",
        "BGEU     ",
        "LD.B     ",
        "LD.H     ",
        "LD.BU    ",
        "LD.HU    ",
        "ST.B     ",
        "ST.H     "
    };

    while (fgets(inst, sizeof(inst), fp) != NULL)
    {
        size_t len = strlen(inst);
        if (len > 0 && (inst[len - 1] == '\n' || inst[len - 1] == '\r'))
        {
            inst[len - 1] = '\0';
            if (len > 1 && inst[len - 2] == '\r')
                inst[len - 2] = '\0';
        }

        char* iname = inst_name(inst);

        if (memcmp(iname, "LU12I.W  ", 9) == 0) inst_map[ 0] = true;
        if (memcmp(iname, "ADD.W    ", 9) == 0) inst_map[ 1] = true;
        if (memcmp(iname, "ADDI.W   ", 9) == 0) inst_map[ 2] = true;
        if (memcmp(iname, "SUB.W    ", 9) == 0) inst_map[ 3] = true;
        if (memcmp(iname, "SLT      ", 9) == 0) inst_map[ 4] = true;
        if (memcmp(iname, "SLTU     ", 9) == 0) inst_map[ 5] = true;
        if (memcmp(iname, "AND      ", 9) == 0) inst_map[ 6] = true;
        if (memcmp(iname, "OR       ", 9) == 0) inst_map[ 7] = true;
        if (memcmp(iname, "XOR      ", 9) == 0) inst_map[ 8] = true;
        if (memcmp(iname, "NOR      ", 9) == 0) inst_map[ 9] = true;
        if (memcmp(iname, "SLLI.W   ", 9) == 0) inst_map[10] = true;
        if (memcmp(iname, "SRLI.W   ", 9) == 0) inst_map[11] = true;
        if (memcmp(iname, "SRAI.W   ", 9) == 0) inst_map[12] = true;
        if (memcmp(iname, "LD.W     ", 9) == 0) inst_map[13] = true;
        if (memcmp(iname, "ST.W     ", 9) == 0) inst_map[14] = true;
        if (memcmp(iname, "BEQ      ", 9) == 0) inst_map[15] = true;
        if (memcmp(iname, "BNE      ", 9) == 0) inst_map[16] = true;
        if (memcmp(iname, "BL       ", 9) == 0) inst_map[17] = true;
        if (memcmp(iname, "JIRL     ", 9) == 0) inst_map[18] = true;
        if (memcmp(iname, "B        ", 9) == 0) inst_map[19] = true;
        if (memcmp(iname, "PCADDU12I", 9) == 0) inst_map[20] = true;
        if (memcmp(iname, "SLTI     ", 9) == 0) inst_map[21] = true;
        if (memcmp(iname, "SLTUI    ", 9) == 0) inst_map[22] = true;
        if (memcmp(iname, "ANDI     ", 9) == 0) inst_map[23] = true;
        if (memcmp(iname, "ORI      ", 9) == 0) inst_map[24] = true;
        if (memcmp(iname, "XORI     ", 9) == 0) inst_map[25] = true;
        if (memcmp(iname, "SLL.W    ", 9) == 0) inst_map[26] = true;
        if (memcmp(iname, "SRA.W    ", 9) == 0) inst_map[27] = true;
        if (memcmp(iname, "SRL.W    ", 9) == 0) inst_map[28] = true;
        if (memcmp(iname, "DIV_W    ", 9) == 0) inst_map[29] = true;
        if (memcmp(iname, "DIV_WU   ", 9) == 0) inst_map[30] = true;
        if (memcmp(iname, "MUL_W    ", 9) == 0) inst_map[31] = true;
        if (memcmp(iname, "MULH_W   ", 9) == 0) inst_map[32] = true;
        if (memcmp(iname, "MULH_WU  ", 9) == 0) inst_map[33] = true;
        if (memcmp(iname, "MOD_W    ", 9) == 0) inst_map[34] = true;
        if (memcmp(iname, "MOD_WU   ", 9) == 0) inst_map[35] = true;
        if (memcmp(iname, "BLT      ", 9) == 0) inst_map[36] = true;
        if (memcmp(iname, "BGE      ", 9) == 0) inst_map[37] = true;
        if (memcmp(iname, "BLTU     ", 9) == 0) inst_map[38] = true;
        if (memcmp(iname, "BGEU     ", 9) == 0) inst_map[39] = true;
        if (memcmp(iname, "LD.B     ", 9) == 0) inst_map[40] = true;
        if (memcmp(iname, "LD.H     ", 9) == 0) inst_map[41] = true;
        if (memcmp(iname, "LD.BU    ", 9) == 0) inst_map[42] = true;
        if (memcmp(iname, "LD.HU    ", 9) == 0) inst_map[43] = true;
        if (memcmp(iname, "ST.B     ", 9) == 0) inst_map[44] = true;
        if (memcmp(iname, "ST.H     ", 9) == 0) inst_map[45] = true;
    }

    int inst_num = 0;
    for (int i = 0; i < 46; i++) if (inst_map[i]) inst_num++;
    fprintf(ofp, "%d tests in total.\n", get_test_num());
    fprintf(ofp, "%d instructions to be implemented:\n\n", inst_num);
    printf("**************************************************\n");
    printf("%d tests in total.\n", get_test_num());
    printf("%d instructions to be implemented.\n", inst_num);
    printf("**************************************************\n");

    for (int i = 0; i < 46; i++)
        if (inst_map[i]) fprintf(ofp, "%s\n", inst_name_tbl[i]);

    fclose(fp);
    fclose(ofp);
}
