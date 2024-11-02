
################################################################
# This is a generated script based on design: top
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2024.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}

   } else {
     catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   }

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source top_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7a50tcsg325-2
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name top

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:user:pcie_axi_lite_v1_0:1.0\
xilinx.com:ip:pcie_7x:3.3\
xilinx.com:ip:util_ds_buf:2.2\
xilinx.com:ip:axi_bram_ctrl:4.1\
xilinx.com:ip:blk_mem_gen:8.4\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:microblaze:11.0\
xilinx.com:ip:mdm:3.2\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:system_ila:1.1\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:lmb_v10:3.0\
xilinx.com:ip:lmb_bram_if_cntlr:4.0\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: microblaze_0_local_memory
proc create_hier_cell_microblaze_0_local_memory { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_microblaze_0_local_memory() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB

  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB


  # Create pins
  create_bd_pin -dir I -type clk LMB_Clk
  create_bd_pin -dir I -type rst SYS_Rst

  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]

  # Create instance: ilmb_v10, and set properties
  set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb_v10 ]

  # Create instance: dlmb_bram_if_cntlr, and set properties
  set dlmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 dlmb_bram_if_cntlr ]
  set_property CONFIG.C_ECC {0} $dlmb_bram_if_cntlr


  # Create instance: ilmb_bram_if_cntlr, and set properties
  set ilmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 ilmb_bram_if_cntlr ]
  set_property CONFIG.C_ECC {0} $ilmb_bram_if_cntlr


  # Create instance: lmb_bram, and set properties
  set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 lmb_bram ]
  set_property -dict [list \
    CONFIG.Memory_Type {True_Dual_Port_RAM} \
    CONFIG.use_bram_block {BRAM_Controller} \
  ] $lmb_bram


  # Create interface connections
  connect_bd_intf_net -intf_net microblaze_0_dlmb [get_bd_intf_pins dlmb_v10/LMB_M] [get_bd_intf_pins DLMB]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_bus [get_bd_intf_pins dlmb_v10/LMB_Sl_0] [get_bd_intf_pins dlmb_bram_if_cntlr/SLMB]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_cntlr [get_bd_intf_pins dlmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net microblaze_0_ilmb [get_bd_intf_pins ilmb_v10/LMB_M] [get_bd_intf_pins ILMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_bus [get_bd_intf_pins ilmb_v10/LMB_Sl_0] [get_bd_intf_pins ilmb_bram_if_cntlr/SLMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_cntlr [get_bd_intf_pins ilmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTB]

  # Create port connections
  connect_bd_net -net SYS_Rst_1 [get_bd_pins SYS_Rst] [get_bd_pins dlmb_v10/SYS_Rst] [get_bd_pins dlmb_bram_if_cntlr/LMB_Rst] [get_bd_pins ilmb_v10/SYS_Rst] [get_bd_pins ilmb_bram_if_cntlr/LMB_Rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins LMB_Clk] [get_bd_pins dlmb_v10/LMB_Clk] [get_bd_pins dlmb_bram_if_cntlr/LMB_Clk] [get_bd_pins ilmb_v10/LMB_Clk] [get_bd_pins ilmb_bram_if_cntlr/LMB_Clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set CLK_IN_D_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 CLK_IN_D_0 ]

  set pcie_7x_mgt_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie_7x_mgt_0 ]

  set GPIO_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 GPIO_0 ]

  set gpio_rtl_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_rtl_0 ]

  set gpio_rtl_1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_rtl_1 ]

  set gpio_rtl_2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_rtl_2 ]

  set CLK_L_IN [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 CLK_L_IN ]

  set CLK_F_IN [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 CLK_F_IN ]

  set ADC_DAT [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 ADC_DAT ]


  # Create ports
  set sys_rst_n_0 [ create_bd_port -dir I -type rst sys_rst_n_0 ]
  set clk_25 [ create_bd_port -dir I clk_25 ]

  # Create instance: pcie_axi_lite_v1_0_0, and set properties
  set pcie_axi_lite_v1_0_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:pcie_axi_lite_v1_0:1.0 pcie_axi_lite_v1_0_0 ]
  set_property -dict [list \
    CONFIG.AXI_BAR_0_ADDR {0xC0000000} \
    CONFIG.AXI_BAR_0_MASK {0xF0000000} \
  ] $pcie_axi_lite_v1_0_0


  # Create instance: pcie_7x_0, and set properties
  set pcie_7x_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:pcie_7x:3.3 pcie_7x_0 ]
  set_property -dict [list \
    CONFIG.Bar0_Scale {Megabytes} \
    CONFIG.Bar0_Size {256} \
    CONFIG.Device_ID {7024} \
    CONFIG.IntX_Generation {false} \
    CONFIG.Interface_Width {128_bit} \
    CONFIG.Legacy_Interrupt {NONE} \
    CONFIG.Link_Speed {5.0_GT/s} \
    CONFIG.MSI_64b {false} \
    CONFIG.Max_Payload_Size {512_bytes} \
    CONFIG.Maximum_Link_Width {X4} \
    CONFIG.PCIe_Blk_Locn {X0Y0} \
    CONFIG.PCIe_Debug_Ports {false} \
    CONFIG.Ref_Clk_Freq {100_MHz} \
    CONFIG.Trans_Buf_Pipeline {None} \
    CONFIG.Trgt_Link_Speed {4'h2} \
    CONFIG.User_Clk_Freq {125} \
    CONFIG.cfg_ctl_if {false} \
    CONFIG.cfg_fc_if {false} \
    CONFIG.cfg_mgmt_if {false} \
    CONFIG.cfg_status_if {false} \
    CONFIG.en_ext_clk {false} \
    CONFIG.err_reporting_if {false} \
    CONFIG.mode_selection {Advanced} \
    CONFIG.pipe_mode_sim {None} \
    CONFIG.pl_interface {false} \
    CONFIG.rcv_msg_if {false} \
  ] $pcie_7x_0


  # Create instance: util_ds_buf_0, and set properties
  set util_ds_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf_0 ]
  set_property CONFIG.C_BUF_TYPE {IBUFDSGTE} $util_ds_buf_0


  # Create instance: axi_bram_ctrl_0, and set properties
  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0 ]

  # Create instance: axi_bram_ctrl_0_bram, and set properties
  set axi_bram_ctrl_0_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 axi_bram_ctrl_0_bram ]
  set_property CONFIG.Memory_Type {True_Dual_Port_RAM} $axi_bram_ctrl_0_bram


  # Create instance: rst_clk_wiz_100M, and set properties
  set rst_clk_wiz_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_100M ]

  # Create instance: microblaze_0, and set properties
  set microblaze_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0 ]
  set_property -dict [list \
    CONFIG.C_DEBUG_ENABLED {1} \
    CONFIG.C_D_AXI {1} \
    CONFIG.C_D_LMB {1} \
    CONFIG.C_ENABLE_CONVERSION {0} \
    CONFIG.C_I_LMB {1} \
  ] $microblaze_0


  # Create instance: microblaze_0_local_memory
  create_hier_cell_microblaze_0_local_memory [current_bd_instance .] microblaze_0_local_memory

  # Create instance: mdm_1, and set properties
  set mdm_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 mdm_1 ]
  set_property -dict [list \
    CONFIG.C_ADDR_SIZE {32} \
    CONFIG.C_M_AXI_ADDR_WIDTH {32} \
    CONFIG.C_USE_UART {1} \
  ] $mdm_1


  # Create instance: spi_gpio_0, and set properties
  set spi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 spi_gpio_0 ]
  set_property CONFIG.C_GPIO_WIDTH {7} $spi_gpio_0


  # Create instance: i2c_gpio_0, and set properties
  set i2c_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 i2c_gpio_0 ]
  set_property CONFIG.C_GPIO_WIDTH {2} $i2c_gpio_0


  # Create instance: led_gpio_0, and set properties
  set led_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 led_gpio_0 ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {13} \
  ] $led_gpio_0


  # Create instance: en_gpio_0, and set properties
  set en_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 en_gpio_0 ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {3} \
  ] $en_gpio_0


  # Create instance: axi_smc, and set properties
  set axi_smc [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_smc ]
  set_property -dict [list \
    CONFIG.NUM_MI {7} \
    CONFIG.NUM_SI {2} \
  ] $axi_smc


  # Create instance: l_clk_buf_0, and set properties
  set l_clk_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 l_clk_buf_0 ]

  # Create instance: f_clk_buf_0, and set properties
  set f_clk_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 f_clk_buf_0 ]

  # Create instance: system_ila_1, and set properties
  set system_ila_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_1 ]
  set_property -dict [list \
    CONFIG.C_DATA_DEPTH {2048} \
    CONFIG.C_EN_STRG_QUAL {1} \
    CONFIG.C_MON_TYPE {MIX} \
    CONFIG.C_NUM_MONITOR_SLOTS {2} \
    CONFIG.C_NUM_OF_PROBES {2} \
    CONFIG.C_PROBE0_TYPE {0} \
    CONFIG.C_PROBE1_TYPE {0} \
    CONFIG.C_PROBE2_TYPE {0} \
    CONFIG.C_PROBE3_TYPE {0} \
    CONFIG.C_PROBE5_TYPE {0} \
    CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:gpio_rtl:1.0} \
    CONFIG.C_SLOT_0_TYPE {0} \
    CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:gpio_rtl:1.0} \
    CONFIG.C_SLOT_1_TYPE {0} \
  ] $system_ila_1


  # Create instance: ila_tap_0, and set properties
  set ila_tap_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 ila_tap_0 ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {1} \
  ] $ila_tap_0


  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [list \
    CONFIG.CLKOUT1_JITTER {103.499} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {266.66667} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F {3.750} \
    CONFIG.PRIM_SOURCE {Global_buffer} \
    CONFIG.USE_LOCKED {false} \
    CONFIG.USE_RESET {false} \
  ] $clk_wiz_0


  # Create instance: util_ds_buf_1, and set properties
  set util_ds_buf_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf_1 ]
  set_property CONFIG.C_SIZE {8} $util_ds_buf_1


  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [list \
    CONFIG.C_EN_STRG_QUAL {1} \
    CONFIG.C_MON_TYPE {NATIVE} \
    CONFIG.C_NUM_OF_PROBES {4} \
    CONFIG.C_PROBE0_TYPE {0} \
    CONFIG.C_PROBE1_TYPE {0} \
    CONFIG.C_PROBE2_TYPE {0} \
  ] $system_ila_0


  # Create interface connections
  connect_bd_intf_net -intf_net CLK_IN_D_0_1 [get_bd_intf_ports CLK_IN_D_0] [get_bd_intf_pins util_ds_buf_0/CLK_IN_D]
  connect_bd_intf_net -intf_net CLK_IN_D_1_1 [get_bd_intf_ports CLK_L_IN] [get_bd_intf_pins l_clk_buf_0/CLK_IN_D]
  connect_bd_intf_net -intf_net CLK_IN_D_1_2 [get_bd_intf_ports ADC_DAT] [get_bd_intf_pins util_ds_buf_1/CLK_IN_D]
  connect_bd_intf_net -intf_net CLK_IN_D_2_1 [get_bd_intf_ports CLK_F_IN] [get_bd_intf_pins f_clk_buf_0/CLK_IN_D]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0_bram/BRAM_PORTA] [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTB [get_bd_intf_pins axi_bram_ctrl_0_bram/BRAM_PORTB] [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTB]
  connect_bd_intf_net -intf_net axi_smc_M00_AXI [get_bd_intf_pins axi_smc/M00_AXI] [get_bd_intf_pins axi_bram_ctrl_0/S_AXI]
  connect_bd_intf_net -intf_net axi_smc_M01_AXI [get_bd_intf_pins axi_smc/M01_AXI] [get_bd_intf_pins mdm_1/S_AXI]
  connect_bd_intf_net -intf_net axi_smc_M02_AXI [get_bd_intf_pins axi_smc/M02_AXI] [get_bd_intf_pins en_gpio_0/S_AXI]
  connect_bd_intf_net -intf_net axi_smc_M03_AXI [get_bd_intf_pins axi_smc/M03_AXI] [get_bd_intf_pins i2c_gpio_0/S_AXI]
  connect_bd_intf_net -intf_net axi_smc_M04_AXI [get_bd_intf_pins axi_smc/M04_AXI] [get_bd_intf_pins led_gpio_0/S_AXI]
  connect_bd_intf_net -intf_net axi_smc_M05_AXI [get_bd_intf_pins axi_smc/M05_AXI] [get_bd_intf_pins spi_gpio_0/S_AXI]
  connect_bd_intf_net -intf_net axi_smc_M06_AXI [get_bd_intf_pins axi_smc/M06_AXI] [get_bd_intf_pins ila_tap_0/S_AXI]
  connect_bd_intf_net -intf_net eni_gpio_0_GPIO [get_bd_intf_ports gpio_rtl_2] [get_bd_intf_pins en_gpio_0/GPIO]
  connect_bd_intf_net -intf_net i2c_gpio_0_GPIO [get_bd_intf_ports gpio_rtl_0] [get_bd_intf_pins i2c_gpio_0/GPIO]
connect_bd_intf_net -intf_net [get_bd_intf_nets i2c_gpio_0_GPIO] [get_bd_intf_ports gpio_rtl_0] [get_bd_intf_pins system_ila_1/SLOT_0_GPIO]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets i2c_gpio_0_GPIO]
  connect_bd_intf_net -intf_net led_gpio_0_GPIO [get_bd_intf_ports gpio_rtl_1] [get_bd_intf_pins led_gpio_0/GPIO]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DP [get_bd_intf_pins microblaze_0/M_AXI_DP] [get_bd_intf_pins axi_smc/S00_AXI]
  connect_bd_intf_net -intf_net microblaze_0_debug [get_bd_intf_pins mdm_1/MBDEBUG_0] [get_bd_intf_pins microblaze_0/DEBUG]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_1 [get_bd_intf_pins microblaze_0/DLMB] [get_bd_intf_pins microblaze_0_local_memory/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_1 [get_bd_intf_pins microblaze_0/ILMB] [get_bd_intf_pins microblaze_0_local_memory/ILMB]
  connect_bd_intf_net -intf_net pcie_7x_0_m_axis_rx [get_bd_intf_pins pcie_7x_0/m_axis_rx] [get_bd_intf_pins pcie_axi_lite_v1_0_0/s_axis_rx]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets pcie_7x_0_m_axis_rx]
  connect_bd_intf_net -intf_net pcie_7x_0_pcie_7x_mgt [get_bd_intf_ports pcie_7x_mgt_0] [get_bd_intf_pins pcie_7x_0/pcie_7x_mgt]
  connect_bd_intf_net -intf_net pcie_axi_lite_v1_0_0_M_AXI [get_bd_intf_pins pcie_axi_lite_v1_0_0/M_AXI] [get_bd_intf_pins axi_smc/S01_AXI]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets pcie_axi_lite_v1_0_0_M_AXI]
  connect_bd_intf_net -intf_net pcie_axi_lite_v1_0_0_m_axis_tx [get_bd_intf_pins pcie_axi_lite_v1_0_0/m_axis_tx] [get_bd_intf_pins pcie_7x_0/s_axis_tx]
  connect_bd_intf_net -intf_net spi_gpio_0_GPIO [get_bd_intf_ports GPIO_0] [get_bd_intf_pins spi_gpio_0/GPIO]
connect_bd_intf_net -intf_net [get_bd_intf_nets spi_gpio_0_GPIO] [get_bd_intf_ports GPIO_0] [get_bd_intf_pins system_ila_1/SLOT_1_GPIO]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets spi_gpio_0_GPIO]

  # Create port connections
  connect_bd_net -net IBUF_OUT [get_bd_pins f_clk_buf_0/IBUF_OUT] [get_bd_pins system_ila_0/probe0]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets IBUF_OUT]
  connect_bd_net -net IBUF_OUT_1 [get_bd_pins l_clk_buf_0/IBUF_OUT] [get_bd_pins system_ila_0/probe1]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets IBUF_OUT_1]
  connect_bd_net -net IBUF_OUT_2 [get_bd_pins util_ds_buf_1/IBUF_OUT] [get_bd_pins system_ila_0/probe2]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets IBUF_OUT_2]
  connect_bd_net -net clk_25_1 [get_bd_ports clk_25] [get_bd_pins system_ila_1/probe0] [get_bd_pins system_ila_0/probe3]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins system_ila_0/clk]
  connect_bd_net -net ila_tap_0_gpio_io_o [get_bd_pins ila_tap_0/gpio_io_o] [get_bd_pins system_ila_1/probe1]
  connect_bd_net -net mdm_1_debug_sys_rst [get_bd_pins mdm_1/Debug_SYS_Rst] [get_bd_pins rst_clk_wiz_100M/mb_debug_sys_rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins pcie_7x_0/user_clk_out] [get_bd_pins pcie_axi_lite_v1_0_0/user_clk] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins rst_clk_wiz_100M/slowest_sync_clk] [get_bd_pins microblaze_0/Clk] [get_bd_pins microblaze_0_local_memory/LMB_Clk] [get_bd_pins mdm_1/S_AXI_ACLK] [get_bd_pins spi_gpio_0/s_axi_aclk] [get_bd_pins i2c_gpio_0/s_axi_aclk] [get_bd_pins led_gpio_0/s_axi_aclk] [get_bd_pins en_gpio_0/s_axi_aclk] [get_bd_pins axi_smc/aclk] [get_bd_pins ila_tap_0/s_axi_aclk] [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins system_ila_1/clk]
  connect_bd_net -net pcie_7x_0_user_lnk_up [get_bd_pins pcie_7x_0/user_lnk_up] [get_bd_pins pcie_axi_lite_v1_0_0/user_lnk_up]
  connect_bd_net -net pcie_7x_0_user_reset_out [get_bd_pins pcie_7x_0/user_reset_out] [get_bd_pins rst_clk_wiz_100M/ext_reset_in]
  connect_bd_net -net rst_clk_wiz_100M_bus_struct_reset [get_bd_pins rst_clk_wiz_100M/bus_struct_reset] [get_bd_pins microblaze_0_local_memory/SYS_Rst]
  connect_bd_net -net rst_clk_wiz_100M_mb_reset [get_bd_pins rst_clk_wiz_100M/mb_reset] [get_bd_pins microblaze_0/Reset]
  connect_bd_net -net rst_clk_wiz_100M_peripheral_aresetn [get_bd_pins rst_clk_wiz_100M/peripheral_aresetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] [get_bd_pins pcie_axi_lite_v1_0_0/M_AXI_ARESETN] [get_bd_pins mdm_1/S_AXI_ARESETN] [get_bd_pins spi_gpio_0/s_axi_aresetn] [get_bd_pins i2c_gpio_0/s_axi_aresetn] [get_bd_pins led_gpio_0/s_axi_aresetn] [get_bd_pins en_gpio_0/s_axi_aresetn] [get_bd_pins axi_smc/aresetn] [get_bd_pins ila_tap_0/s_axi_aresetn]
  connect_bd_net -net sys_rst_n_0_1 [get_bd_ports sys_rst_n_0] [get_bd_pins pcie_7x_0/sys_rst_n]
  connect_bd_net -net util_ds_buf_0_IBUF_OUT [get_bd_pins util_ds_buf_0/IBUF_OUT] [get_bd_pins pcie_7x_0/sys_clk]

  # Create address segments
  assign_bd_address -offset 0xC0000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces pcie_axi_lite_v1_0_0/M_AXI] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0xC0010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces pcie_axi_lite_v1_0_0/M_AXI] [get_bd_addr_segs en_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0xC0040000 -range 0x00010000 -target_address_space [get_bd_addr_spaces pcie_axi_lite_v1_0_0/M_AXI] [get_bd_addr_segs i2c_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0xC00C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces pcie_axi_lite_v1_0_0/M_AXI] [get_bd_addr_segs ila_tap_0/S_AXI/Reg] -force
  assign_bd_address -offset 0xC0020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces pcie_axi_lite_v1_0_0/M_AXI] [get_bd_addr_segs led_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x41400000 -range 0x00001000 -target_address_space [get_bd_addr_spaces pcie_axi_lite_v1_0_0/M_AXI] [get_bd_addr_segs mdm_1/S_AXI/Reg] -force
  assign_bd_address -offset 0xC0030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces pcie_axi_lite_v1_0_0/M_AXI] [get_bd_addr_segs spi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0xC0000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
  assign_bd_address -offset 0x00000000 -range 0x00004000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs microblaze_0_local_memory/dlmb_bram_if_cntlr/SLMB/Mem] -force
  assign_bd_address -offset 0xC0010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs en_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0xC0040000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs i2c_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0xC00C0000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs ila_tap_0/S_AXI/Reg] -force
  assign_bd_address -offset 0xC0020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs led_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x41400000 -range 0x00001000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs mdm_1/S_AXI/Reg] -force
  assign_bd_address -offset 0xC0030000 -range 0x00010000 -target_address_space [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs spi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x00004000 -target_address_space [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs microblaze_0_local_memory/ilmb_bram_if_cntlr/SLMB/Mem] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


