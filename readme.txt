cd raw_data_process
copy raw text files in it

cd ../
run first.sh

cd raw_data_process
run csv_to_mat.m (converts merged.csv to merged.mat)
copy merged.csv

cd ../create_localization_data/get_sec_data
run sec_data.m
copy sec_139.mat 

cd ../ncell_to_bcch
copy bcch_ncell_sec_139.mat

cd ../localization_data
the folder should already contain ci_lat_lon.mat

run unique_neighbours.m (finds actual bcch frequencies corresponding to bcch values obtained)

copy cell_bcch,cell_bsic,cell_name.mat from ../complete_cell_data

run get_the_pairs.m --> my_map.mat (creates a mapping of bcch, bsic to cell IDs)

run get_final_data.m (looks like there is some issue with the data finally generated)
optional: run stats_of_final_data.m

copy final_data.mat in localize folder
run get_required_data.m 

dependencies : abs_dist.mat, ci_lat_lon.mat, deg2utm, dist_from_pathlossindb, circle, distance.m, dbm_p.m
run localization_v2.m (to localize the complete data)
run get_the_dist_v3..m (to localize a single trace file)

run get_ue_pow.m

dependency : latlon2
run vor.m


