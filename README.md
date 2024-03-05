# **Metatube**

Metatube est une application mobile développée avec Flutter qui permet aux utilisateurs de découvrir et de regarder des vidéos directement dans l'application.

# Fonctionnalités

Connexion utilisateur : les utilisateurs peuvent se connecter à leur compte pour accéder à leur contenu personnalisé.
Lecture de vidéos : les utilisateurs peuvent lire des vidéos directement dans l'application.
Like de vidéos : les utilisateurs peuvent liker les vidéos qu'ils préfèrent.

# API Backend

L'application utilise une API créée en Node.js pour l'authentification et la gestion des vidéos et des likes. L'API est hébergée à l'adresse suivante : [Metatube API](https://metatubeapi.onrender.com/#/)

# Configuration

Le projet utilise flutter_dotenv pour gérer les variables d'environnement.

# Dépendances

Le projet utilise les dépendances suivantes :

go_router: Un package de routage pour Flutter qui fournit une manière simple et déclarative de gérer la navigation dans votre application.

google_nav_bar: Un package pour afficher une barre de navigation en bas de l'application, similaire à celle utilisée dans les applications Google.

http: Un package pour effectuer des requêtes HTTP dans votre application Flutter.

flutter_dotenv: Un package pour charger et utiliser des variables d'environnement à partir d'un fichier .env.

video_player: Un package pour afficher et contrôler la lecture de vidéos dans votre application.

flutter_secure_storage: Un package pour stocker de manière sécurisée des données sensibles telles que les jetons d'authentification.

image_picker: Un package pour sélectionner des images à partir de la galerie ou de l'appareil photo de l'appareil.

flutter_native_splash: Un package pour configurer et afficher une splash screen personnalisée au démarrage de l'application.

# Navigation

La navigation dans cette application est gérée par Go Router, un package de routage pour Flutter. Go Router fournit une manière simple et déclarative de gérer la navigation dans votre application, en utilisant des routes définies de manière modulaire.

Pour configurer les routes et gérer la navigation, consultez le fichier router.dart. Vous y trouverez les définitions de toutes les routes de l'application, ainsi que la logique de navigation associée.

# Information

Ce projet est encore en cours de développement et plein d'autres fonctionnalités seront ajoutées plus tard ! 
