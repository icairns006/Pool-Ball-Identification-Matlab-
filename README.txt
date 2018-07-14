# Pool-Ball-Identification-Matlab-

Look through Ian_Cairns_FinalPresentation.pdf for a more in depth look at what is going on. 


This code finds pool balls in professional billiards competition images. The images are birds eye views of the table. The code uses Hough lines to detect the table and pockets. It then uses Hough circles to find potential balls. The code filters out any circles that are on the table. It then uses a trained Support vector machine to find pool balls. Once the balls are identified the code determines what are possible shot options depending on if the player is solids or stripes. 

The Support vector machine was trained using images I cut of our many competition videos. There are categories for each ball as well as categories for incorrect balls, such as pockets, open table and edges of the table. 

The pdf presentation shows images of the code running and describes what is going on at each step. 

To run the code from start to finish use the extractBalls.m to cut out images of pool balls from an image of the full pool table. Then run the extractFeatures1.m to get the features for training the Support Vector machine. Lastly run the Pool3Code.m to find pool balls in the birds eye image of the pool table. Then select whether you are solids or stripes using the matlab command line. The code will then display the easiest shot for the user to hit. 