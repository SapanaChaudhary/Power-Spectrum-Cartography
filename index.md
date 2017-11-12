###

This project is a part of the work that I am doing with [Dr. Radha Krishna Ganti](http://www.ee.iitm.ac.in/~rganti/). 
In this project, startig from raw GSM data, I have used an empirical model of the environment to first localize users roughly. Following this, I generate power spectrum maps over the given geographical region. The project is implemented in matlab from scratch.   

#### Description of the GSM data 
The data for the purpose of this project is RSL(Radio Signaling Link) data recorded by the Abis Interface. Abis interface is the interface between between BTS and BSC as shown in the diagram below:

The data given by BSNL is from the 3rd layer of Abis Interface Protocol stack. They
have provided RSL data. RSL stands for Radio Signalling Link ([more](http://what-when-how.com/roaming-in-wireless-networks/gsm-interfaces-and-protocols-global-system-for-mobile-communication-gsm-part-2/)).

The hardware used for recording this data is provided by Huawei Technologies Co., Ltd. We sincerely thank BSNL, Coimbatore, India for providing us with the data.

The GSM protocol lists 43 different types of messages that are exchanged between BSC and BTS at the Abis Interface. These messages are broadly categorized into messages for RLM, CCM & TRXM and DCM.

Our data contains the following message types, in Uplink and Downlink directions:

> Abis, BCCH, BS, BTS, Channel, Connection, Data, Deactivate, Direction, Error, Establish, Handover, Immediate, MS,
> Measurement, RF, Release, SACCH, SMS

Following is an instance of trace file from the data: (Fields followed by the values taken by those fields)
```
Index  Report  Time  Interface  Type  Message  Type  Direction  Location  Condition  Content

50137  2016-09-30 11:30:11 910  Abis Interface RSL  Abis Cell Pack Page Command     Downlink   Site ID: 12,Cell ID: 5, TRX No.: 0   7F F0 00 01 00 00 01 53 7F F0 00 01 00 00 01 38 00 00 00 18 00 96 FF FF 00 29 00 00 00 00 00 0C AA 18 01 00 0C 05 F4 1A 64 76 85 01
```
We have data recorded over 16/09/30 2:59:49 PM to 16/09/30 3:20:14 PM.

* * *
#### Data Extraction
The obtained raw data, in the form mentioned above, contains a lot more messages and fields(within those messages) than are useful for the purpose of this project. In this section we extract the useful data. The traces corresponding to message type = ‘Measurement Report’ are extracted and dumped into new set of text files. Each of these text files are then given to the code that outputs csv files consisting of the following fields(column-wise) in the same order:

> day, month, year, hour, minutes, seconds, millisecond, site_id, cell_id, trx_values, ul_sender_cpu_id, ul_sender_pid
> ul_receiver_cpu_id, ul_receiver_pid, ul_length, msg_type, handle, crdlc_ccb, mtls_ccb, auc_reserved, data_length,
> channel_type, time_slot, rxlev_ncell2, rxlev_full_up, rxqual_full_up, rxqual_sub_up, tlv_type_rx_main_level,
> tlv_type_rx_sub_level, bs_reserved, bs_power_level, ms_power_level, ms_reserved, actual_timing_adv, timing_reserved
> enhanced_meas_msg_type, ba_used, dtx_used, rx_lev_full_serving_cell, ba_used_3g, meas_valid, rx_lev_sub_serving_cell
> spare, rx_qual_full_serving_cell, rx_qual_sub_serving_cell, no_n_cell rxlev_ncell_1, bcch_freq_ncell_1, bsic_ncell_1
> rxlev_ncell_2, bcch_freq_ncell_2, bsic_ncell_2, rxlev_ncell_3, bcch_freq_ncell_3, bsic_ncell_3, rxlev_ncell_4
> bcch_freq_ncell_4, bsic_ncell_4, rxlev_ncell_5, bcch_freq_ncell_5, bsic_ncell_5, rxlev_ncell_6, bcch_freq_ncell_6,
> bsic_ncell_6

Sectorized data:
The Samathur BS(Base Station) has 3 sectors encompassing 65 degrees each.
Figure below depicts the antenna locations for Samathur.
Sectors are numbered as 139(Sec-1), 140(Sec-2 and 141(Sec-3).

The mat files sec_139, sec_140 and sec_141 contain the complete sector data with timing information.

The cellular data is now available as a 220327\*64 matrix contained in sec_139.mat. 64 is the number of fields(occurring in the same order) as listed above. 220327 is the number of traces, each recorded approximately at an interval of 46.7622 ms. This would mean unique user data comes in approximately at every 11th reading.  

* * *
#### Processing data for the localization algorithm


* * *

* * *



Text can be **bold**, _italic_, or ~~strikethrough~~.

[Link to another page](another-page).

There should be whitespace between paragraphs.

There should be whitespace between paragraphs. We recommend including a README, or a file with information about your project.

# [](#header-1)Header 1

This is a normal paragraph following a header. GitHub is a code hosting platform for version control and collaboration. It lets you and others work together on projects from anywhere.

## [](#header-2)Header 2

> This is a blockquote following a header.
>
> When something is important enough, you do it even if the odds are not in your favor.

### [](#header-3)Header 3

```matlab
% inverted okumura hata model
function [d] = dist_from_pathlossindb(lo)
% lu = path loss in dB from small sized city
% lo = path loss in dB from open area
f=900;
hm=2.5; % average mobile station height
hb=35;

% okumara hata model
% d is in meters
% ch =3.2*(log10(11.75*hm))^2-4.97 ; for large cities
ch = 0.8 + (1.1*log10(f)-0.7)*hm - 1.56*log10(f);
lu = lo + 4.78*(log10(f))^2 - 18.33*log10(f) + 40.94 ; 
d = 1000*10^((lu - 69.55 - 26.16*log10(f) + 13.82*log10(hb)+ ch)/(44.9-6.55*log10(hb)));
```

#### [](#header-4)Header 4

*   This is an unordered list following a header.
*   This is an unordered list following a header.
*   This is an unordered list following a header.

##### [](#header-5)Header 5

1.  This is an ordered list following a header.
2.  This is an ordered list following a header.
3.  This is an ordered list following a header.

###### [](#header-6)Header 6

| head1        | head two          | three |
|:-------------|:------------------|:------|
| ok           | good swedish fish | nice  |
| out of stock | good and plenty   | nice  |
| ok           | good `oreos`      | hmm   |
| ok           | good `zoute` drop | yumm  |

### There's a horizontal rule below this.

* * *

### Here is an unordered list:

*   Item foo
*   Item bar
*   Item baz
*   Item zip

### And an ordered list:

1.  Item one
1.  Item two
1.  Item three
1.  Item four

### And a nested list:

- level 1 item
  - level 2 item
  - level 2 item
    - level 3 item
    - level 3 item
- level 1 item
  - level 2 item
  - level 2 item
  - level 2 item
- level 1 item
  - level 2 item
  - level 2 item
- level 1 item

### Small image

![](https://assets-cdn.github.com/images/icons/emoji/octocat.png)

### Large image

![](https://guides.github.com/activities/hello-world/branching.png)


### Definition lists can be used with HTML syntax.

<dl>
<dt>Name</dt>
<dd>Godzilla</dd>
<dt>Born</dt>
<dd>1952</dd>
<dt>Birthplace</dt>
<dd>Japan</dd>
<dt>Color</dt>
<dd>Green</dd>
</dl>

```
Long, single-line code blocks should not wrap. They should horizontally scroll if they are too long. This line should be long enough to demonstrate this.
```

```
The final element.
```

