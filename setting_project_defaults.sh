#~/usr/bin/env sh
prj=\'$1\'
echo $prj

cryosparcm cli "set_project_param_default($prj, 'exec_path', '/usr/local/anaconda3/bin/topaz')"


cryosparcm cli "set_project_param_default($prj, 'class2D_max_res', 12)"
cryosparcm cli "set_project_param_default($prj, 'class2D_num_full_iter_batchsize_per_class', 300)"
cryosparcm cli "set_project_param_default($prj, 'intermediate_plots', False)"

cryosparcm cli "set_project_param_default($prj, 'accel_kv',120)"
cryosparcm cli "set_project_param_default($prj, 'cs_mm',2.7)"
cryosparcm cli "set_project_param_default($prj, 'total_dose_e_per_A2',200)"
cryosparcm cli "set_project_param_default($prj, 'psize_A',3.1)"
cryosparcm cli "set_project_param_default($prj, 'negative_stain_data',False)"
cryosparcm cli "set_project_param_default($prj, 'diameter', 200)"
cryosparcm cli "set_project_param_default($prj, 'diameter_max', 300)"
