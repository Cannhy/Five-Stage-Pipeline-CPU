/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

#include "xsi.h"

struct XSI_INFO xsi_info;



int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    work_m_00000000000020667296_3224323566_init();
    work_m_00000000000757812877_1385824202_init();
    work_m_00000000003546304421_3955681987_init();
    work_m_00000000000170718478_2663932823_init();
    work_m_00000000001231361316_3650585529_init();
    work_m_00000000002601699906_2862431528_init();
    work_m_00000000000846809470_4066630463_init();
    work_m_00000000004277879362_1878644346_init();
    work_m_00000000001591637876_4111503280_init();
    work_m_00000000001805880688_4245161272_init();
    work_m_00000000000834316364_1602854331_init();
    work_m_00000000000327970087_4140825114_init();
    work_m_00000000000641750449_2694143388_init();
    work_m_00000000002965791280_3975733304_init();
    work_m_00000000003371903937_1977160344_init();
    work_m_00000000003709189429_2539103599_init();
    work_m_00000000002941796043_3508565487_init();
    work_m_00000000004134447467_2073120511_init();


    xsi_register_tops("work_m_00000000002941796043_3508565487");
    xsi_register_tops("work_m_00000000004134447467_2073120511");


    return xsi_run_simulation(argc, argv);

}