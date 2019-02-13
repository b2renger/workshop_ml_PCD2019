Repo for the code of the machine learning workshop at [Stereolux](https://www.stereolux.org/) for the [processing community days](https://day.processing.org/).

We will explore possibilities to run AI and ML algorithms with [Processing](https://processing.org/) and [p5js](https://p5js.org/) using [Runwayml](https://runwayapp.ai/) and [ML5js](https://ml5js.org/).


# Références artistiques

## Artistes

[Mario Klingemann](http://quasimondo.com/) 
  
- https://www.sothebys.com/en/articles/artificial-intelligence-and-the-art-of-mario-klingemann

- https://twitter.com/quasimondo
  
[Gene Kogan](http://genekogan.com/) 

[Cristóbal Valenzuela](https://cvalenzuelab.com/)

## Projets

[Quick draw by google](https://quickdraw.withgoogle.com/)
    
[chAIr by Philipp Schmitt](https://philippschmitt.com/work/chair)   
    
[Unseen portrait by Philipp Schmitt](https://philippschmitt.com/work/unseen-portraits)  
    
[shelley.ai](http://shelley.ai/) 
 
[ai.experiments](https://experiments.withgoogle.com/collection/ai)

[magenta](https://magenta.tensorflow.org/demos/web/)

[img2txt2img2txt](https://b2renger.github.io/Runway-experiment-img2txt2img2txt/index.html)
    
[esops fables](https://towardsdatascience.com/lets-read-a-story-a-study-on-storytelling-for-children-using-machine-learning-tools-1b631bbbffac)


# Les outils

## runway 

https://runwayapp.ai/ 

## ml5js

https://ml5js.org/  


# Les différents modèles disponnibles

## Tracking

### posenet (runway && ml5js)

Analyser la position (pose) d'une ou plusieures personnes.

- https://ml5js.org/docs/posenet-webcam
- /runway_processing_osc/posenet/


### facelandmarks (runway)

Analyser les contours du visage, des yeux, du nez... d'une ou plusieures personnes.

- /runway_processing_osc/face_landmarks/


### regression with feature extraction (ml5js)

Avec ce type d'algorithme il est possible de tracker la position d'un élément dans une image : on peut par exemple entrainer le programme à suivre la position de notre nez et la répercuter sur un élément gui.

- https://ml5js.org/docs/custom-regression


## Description d'images

Ces algorithmes permettent de classifier des images, de labeliser / reconnaitre des objets dans des images.


### img2txt (runway)

Décrire le contenu d'une image.

- /runway_processing_osc/coco_ssd


### mobilenet (runway && ml5js)

Classifier le contenu d'une image.

- /runway_processing_osc/mobilenet
- https://ml5js.org/docs/image-classification-example
- https://ml5js.org/docs/video-classification-example


### coco-ssd (runway)

Analyser le contenu d'une image et retourner une liste d'objets reconnus ainsi que leur bounding box.

- /runway_processing_osc/coco_ssd


### yolo (ml5js)

Analyser le contenu d'une image et retourner une liste d'objets reconnus ainsi que leur bounding box.

- https://ml5js.org/docs/yolo-webcam


## Transformation d'images (runway && ml5js)

### style transfer (ml5js)

Permet de transformer une image en copiant le style d'une autre image.

- https://ml5js.org/docs/style-transfer-image-example
- https://ml5js.org/docs/style-transfer-webcam-example

Entrainer son propre modèle à partir d'une image :

- https://github.com/ml5js/training-styletransfer
- https://b2renger.github.io/WeeklyThemeChallenge/week16_samourai/


### adaptative style transfer (runway)

Méthode plus perfectionnée de style transfer.

Recevoir une image provenant de la runway dans processing via http (le code osc n'est pas supporté pour l'instant) :
- runway_processing_http/adaptative_style_transfer

Envoyer une image depuis p5js à runway
- runway_p5js_socketio/adaptative_file_transfer_send


## Classifiers (ml5js)

Ces techniques permettent d'entrainer un modèle pour reconnaitre le contenu d'une image à la manière de [the teachable machine](https://teachablemachine.withgoogle.com/)

- Classification with feature extraction (avec mobilenet) : https://ml5js.org/docs/custom-classifier
- Possibilité de sauvegarder et charger un modèle entrainé (avec mobilenet) : https://ml5js.org/docs/knnclassifier-featureextractor
- Classification sur des positions de squelette (avec posenet) : https://ml5js.org/docs/knnclassifier-posenet


## Dessin (ml5js)

Cet algorithme utilise comme base de données les millions de dessins produits par les utilisateurs de Quick Draw pour créer de nouveaux doodles en fonction de catégories.

- https://ml5js.org/docs/sketchrnn-example


## Génération de texte (ml5js)

- https://ml5js.org/docs/lstm-example
- https://ml5js.org/docs/lstm-interactive-example



# Idées de projets 

- démineur avec posenet (cf dossier /ml5js)
- dj avec knn classifier (cf dossier /ml5js)

- google dessines moi un mouton => sketchRNN && STT
- eat the candies => face tracker
- generation d'histoires depuis webcam => ltsm + yolo ou ltsm + video classification


# Ressources supplémentaires

- http://ml4a.github.io/demos/ (ml5js)
- https://github.com/kylemcdonald/ofxFaceTracker/releases 
- https://ml4a.github.io/ml4a/introduction/
- https://github.com/stc/face-tracking-p5js
- https://github.com/stc/semantic-vision-workshop




