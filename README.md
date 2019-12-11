# The Role of Sensory Uncertainty in Simple Contour Integration

This repository accompanies the manuscript by Zhou, Acerbi and Ma (2018). It includes human subjects' data and the MATLAB code used for fitting and comparing the models reported in the paper.

#### Data files

All subjects' raw data can be found in the `./data` folder, stored either in the `newsubjdata.mat` file or in individual `.csv` files for each subject and task. `newsubjdataC` denote data for the *collinearity judgment* task and `newsubjdataD` for the *height judgment* task (see paper for details). 
For each subject and task, the data table contains the following columns:
1. Eccentricity level (pixel)	
2. Offset (pixel)	
3. Trial type: 0 (non-collinear) or 1 (collinear)	
4. Response: 0 (non-collinear) or 1 (collinear)	
5. Confidence rating: 1 (lowest confidence) - 4 (highest confidence)	
6. Left line height (pixel)	
7. Right line height (pixel)	
8. Reaction time (s)

#### Model fitting

Code used to perform the model comparison reported in the paper is available in the `./code` folder. Commented code to run a model fit for a single subject and task is available in the example file `model_fitting_example.m`. This example script will run both maximum-likelihood estimation (MLE) and posterior sampling via Markov Chain Monte Carlo (MCMC), as described in the paper.

To run the code, ensure to have installed these external MATLAB toolboxes:
- Bayesian Adaptive Direct Search (BADS) for optimization, available [here](https://github.com/lacerbi/bads);
- Ensemble (inversion) slice sampling *lite* for MCMC sampling, available [here](https://github.com/lacerbi/eissample).


## Reference

1. Zhou, Y.\*, Acerbi, L.\* & Ma, W. J. (2018) The Role of Sensory Uncertainty in Simple Perceptual Organization, *biorXiv preprint*. (\*equal contribution authors; [link](https://www.biorxiv.org/content/10.1101/350082v2))

### License

All MATLAB files in the `code` folder are released under the terms of the [MIT license](https://github.com/yanlizhou/collinearity/blob/master/LICENSE).
