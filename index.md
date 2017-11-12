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

* * *

* * *

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

