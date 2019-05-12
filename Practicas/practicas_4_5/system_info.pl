#!/usr/bin/perl

##############################################
### Developer: Pacheco Franco Jesús Enrique ##
### Date: May 11, 2019 #######################
### Assignment: Practice 04 ##################
### Description: system info #################
##############################################

@sys_info = `C:\\Windows\\system32\\systeminfo.exe`;

@host_name = grep {/^Nombre de host/} @sys_info;
@tmp = split /:\s+/, @host_name[0];
print("host_name: " . @tmp[1]);

@user = grep {/^Propiedad de/} @sys_info;
@tmp = split /:\s+/, @user[0];
print("user: " . @tmp[1]);

@OS = grep {/^Nombre del sistema operativo/} @sys_info;
@tmp = split /:\s+/, @OS[0];
print("OS: " . @tmp[1]);

@arch = grep {/^Tipo de sistema/} @sys_info;
@tmp = split /:\s+/, @arch[0];
print("architecture: " . @tmp[1]);

@ram = grep {/^Cantidad total de memoria/} @sys_info;
@tmp = split /:\s+/, @ram[0];
print("RAM: " . @tmp[1]);

foreach $i (0..$#sys_info) {
	if(grep {/^Procesador/} @sys_info[$i]) {
		@tmp = split /:\s+/, @sys_info[$i+1];
		print("Processor: " . @tmp[1]);
	}
}

foreach $i (0..$#sys_info) {
	if(grep {/^\s+Nombre de conexi.n: Ethernet/} @sys_info[$i]) {
		@tmp = split /:\s+/, @sys_info[$i+4];
		print("ip_address: " . @tmp[1]);
		last;
	}
}

$stop = <STDIN>;