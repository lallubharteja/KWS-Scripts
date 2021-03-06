# KWS Scripts
Recipe to setup and run Kaldi's keyword search system for character- and morpheme-based ASR. We create these subword ASR systems using the kaldi recipe scripts available at [1,2]. These systems are then used to setup the keyword search task using the following scripts. Note, that some these scripts are specific to our system and will need to modified suitably for your own systems.

We also provide Arabic and Finnish OOV lists to setup Keyword Search tasks for both these languages. Both the OOV lists are written using the roman alphabet. The arabic OOV list was converted form the original script to roman alphabet using the buckwalter transliteration [3]. 

## Prerequisites
You will need the latest version of the following tools:
- kaldi toolkit - https://github.com/kaldi-asr/kaldi. Also, make sure kaldi c++ tools are in your path 
- python3 
- NIST F4DE toolkit - https://github.com/usnistgov/F4DE
- Symlinks: To run the scripts in this recipe, we assume that the following symlinks exist in your experiments directory
 - `steps` is linked to `kaldi-trunk/egs/wsj/s5/steps`
 - `utils` is linked to `kaldi-trunk/egs/wsj/s5/utils`
 - `local_kws` is linked to `kaldi-trunk/egs/babel/s5c/local`

## Setting up Keyword Search Task
###### Create a keyword list
You can setup your own set of important words as keywords. Or you can use `get_oov.py` to set up an Out-of-Vocabulary (OOV) based keyword list. This script takes the evaluation set (`test.txt`) and training set vocabulary (`voc`) as inputs and prints the OOVs to stdout.

```
python3 get_oovs.py data/wsj/test.txt data/wsj/voc > keywords.lst
```
Above, we assume that `test.txt` and `voc` contain words. For a subword ASR system, you will have to break the keywords into their constituent subwords seperated by spaces. Kaldi's keyword search system allows searching for phrases as well and thus, searching for the subword sequences is also possible. For our subword ASR systems, we use the `run_pre_kw_list.sh` script to segment the keywords to subwords and then store it an xml format as required by Kaldi's OpenKWS [4] and NIST's F4DE setup [5].

###### Create the Experiment Control File
An Experiment Control File (ECF) is required by the NIST's F4DE setup for evaluation. Refer [5] for more details on defining this file. You can create this file using the following command. 
```
kws_scripts/create_ecf_file.sh data/wsj/wav.scp data/kws_prep/ecf.xml
```
It takes a list of wav files and outputs an ECF in required xml format.

###### Create the RTTM File
A reference file (RTTM) to search keywords is required by the F4DE setup [5]. To create this file, we utilize Kaldi's `ali_to_rttm.sh` scripts. You will need to create an ali directory using your acoustic model and related files. An example of these two steps is recorded in `create_rttm.sh`.

###### Setup KWS data directory for Kaldi
To setup the keyword search data, you will need to perform a decoding pass with your language model with Kaldi. In process, you will create a lexicon and dataset features directory that will be used to setup the KWS task. An example of using these files to create KWS data directory is provided in `run_kws_setup.sh`.

## Running KWS
Finally the keyword search can be run using `run_kws_task.sh`. This script specifies the data and other requirements for running the KWS for subword ASR setup.

# OOV Lists
Two oov lists are contained in this repository:
- `oov_arabic_buckwalter.keywords`: list of MGB3 Arabic OOV words in Buckwalter format
- `oov_finnish.keywords`: list of Finnish OOV words

We also provide a classification of Finnish OOV words in to Foreign, Colloquial, Common Nouns, Proper Nouns, Numeral, Verbs and other categories in the `oov_lists` directory.

# Citing
Bibtex entry for citing: 
```
@inproceedings{SubwordKWS19,
  author = {Mittul Singh, Sami Virpioja, Peter Smit, Mikko Kurimo},
  title = {Subword RNNLM Approximations for Out-Of-Vocabulary Keyword Search},
  year = {2019},
  pages = {to appear},
  booktitle = {INTERSPEECH}
}
```
Of course cite Kaldi Toolkit for these scripts as well.


# References
[1] https://github.com/aalto-speech/subword-kaldi

[2] https://github.com/psmit/kaldi-recipes

[3] http://www.mgb-challenge.org/arabic.html

[4] http://kaldi-asr.org/doc/kws.html

[5] https://www.nist.gov/sites/default/files/documents/itl/iad/mig/OpenKWS13-EvalPlan.pdf
