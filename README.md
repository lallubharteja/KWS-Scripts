# kws_scripts
Recipe to setup and run Kaldi's keyword search system for character- and morpheme-based ASR. We create these subword ASR systems using the kaldi recipe scripts available at [1,2]. These systems are then used to setup the keyword search task using the following scripts. Note, that some these scripts are specific to our system and will need to modified suitably for your own systems.

## Prerequisites
You will need the latest version of the following tools:
- kaldi toolkit - https://github.com/kaldi-asr/kaldi
- python3 
- NIST F4DE toolkit - https://github.com/usnistgov/F4DE
- sox
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
Above, we assume that `test.txt` and `voc` contain words. For a subword ASR system, you will have to break the keywords into their constituent subwords seperated by spaces. Kaldi's keyword search system allows searching for phrases as well and thus, searching for the subword sequences is also possible. For our subword ASR systems, we use the `run_pre_kw_list.sh` script to segment the keywords to subwords and then store it an xml format as required by Kaldi's OpenKWS [3] and NIST's F4DE setup [4].

###### Create the Experiment Control File
An Experiment Control File (ECF) is required by the NIST's F4DE setup for evaluation. Refer [4] for more details on defining this file. You can create this file using the following command. 
```
kws_scripts/create_ecf_file.sh data/wsj/wav.scp data/kws_prep/ecf.xml
```
It takes a list of wav files and outputs an ECF in required xml format.

###### Create the RTTM File
A reference file (RTTM) to search keywords is required by the F4DE setup [4]. To create this file, we utilize Kaldi's `ali_to_rttm.sh` scripts. You will need to create an ali directory using your acoustic model and related files. An example of these two steps is recorded in `create_rttm.sh`.

###### Setup KWS data directory for Kaldi
To setup the keyword search data, you will need to perform a decoding pass with your language model with Kaldi. In process, you will create a lexicon and dataset features directory that will be used to setup the KWS task. An example of using these files to create KWS data directory is provided in `run_kws_setup.sh`.

## Running KWS
Finally the keyword search can be run using `run_kws_task.sh`. This script specifies the data and other requirements for running the KWS for subword ASR setup.

# Citing
Bibtex entry for citing: 
```
@misc{SubwordKWS18,
  author = {Mittul Singh},
  title = {Subword ASR based Keyword Search Recipe},
  year = {2018},
  publisher = {GitHub},
  journal = {GitHub repository},
  howpublished = {\url{https://github.com/lallubharteja/kws_scripts}}
}
```


# References
[1] https://github.com/aalto-speech/subword-kaldi

[2] https://github.com/psmit/kaldi-recipes

[3] http://kaldi-asr.org/doc/kws.html

[4] https://www.nist.gov/sites/default/files/documents/itl/iad/mig/OpenKWS13-EvalPlan.pdf
