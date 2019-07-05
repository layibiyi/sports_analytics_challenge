### \*Currently working on Python-based report of the original submission

## Sports Analytics Challenge Summary
* [2019 Analytics challenge](https://www.agorize.com/en/challenges/xpsg) organized by **Paris Saint-Germain** and **École Polytechnique**

* **Prizes**: $100,000 research funding, Top 5, Top 11, Top 50 prizes.

* **Data**: based on 2016/2017 French Football league matches. (Opta F24 files)

* **Task**: Train an algorithm on the first part of the season that will be tested on the second part of the season, after significant data redaction. Algorithm will have to return the identity of a player who has performed certain actions as well as predictions about the next event to take place on that game.

* **Approach**: F24 xml files inspected and parsed based on desirable features. Feature engineering considered eventual testing scenario and required multiple iterations. Different models were built for each deliverable due to test data redation and desirable model performance. Selected learning algorithms were Random Forest, CART, GLM and Adaptive Mixture Discriminant Analysis.

* **Results**: [Top 11 selection](https://www.agorize.com/en/challenges/xpsg/pages/finale) out of over 3000 submissions. Round 2 interview with analysts from Paris Saint-Germain and École Polytechnique. Finished [8th](https://www.agorize.com/en/challenges/xpsg/pages/finale) and received Paris Saint-Germain merchandise

* **Files uploaded or planned**: 
  - 1st report about original submission ([R](https://layibiyi.github.io/sports_analytics_challenge/challenge_R_report.md) and Python versions). 
  - 2nd report detailing alternate approaches and improvements to original submission (R and Python versions).
  - [main_psgx.R](https://github.com/layibiyi/sports_analytics_challenge/blob/master/main_psgx.R) contains final code submitted. This file loads trained models and includes function that outputs challenge deliverables in a csv file.
    


