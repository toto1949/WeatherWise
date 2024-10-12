# WeatherWise App

## Overview

**WeatherWise** is a weather-based application that allows users to search for weather conditions in US cities using the OpenWeatherMap API. The app includes location-based weather retrieval, displays weather icons, and caches the last searched city for automatic loading on the next app launch. Designed with clean architecture and best practices, this app is optimized for smooth user interactions and adaptability across different screen sizes and orientations.

## Features

1. **Search for US Cities**: Users can search for weather information by entering a US city name.
2. **Auto-Location Detection**: If the user grants location access, the app retrieves weather data based on the user's current location by default.
3. **Weather Icons**: The app downloads and displays weather icons to match the conditions.
4. **Last City Cache**: The last searched city is automatically loaded upon app launch for user convenience.
5. **Image Caching**: Cached images are used to ensure efficient loading and data retrieval.
6. **Orientation and Size Classes**: Full support for both landscape and portrait orientations, adapting the UI for different screen sizes.
7. **Unit Testing**: Comprehensive unit tests for the ViewModel and Model layers.
8. **Error Handling**: Provides user-friendly messages in case of errors, such as network failures or API issues.

## Architecture

- **MVVM-C (Model-View-ViewModel-Coordinator)**: Ensures separation of concerns and easy-to-maintain code:
  - *Model*: Handles data and business logic.
  - *View*: Manages UI presentation.
  - *ViewModel*: Manages presentation logic.
  - *Coordinator*: Manages navigation and dependencies between view controllers.
  
- **Dependency Injection**: Implements dependency injection for better management of dependencies and improving testability.

- **UIKit and SwiftUI**: Leverages a combination of UIKit and SwiftUI for modern and reactive user interfaces. The app avoids using storyboards.

## API Details

The app integrates with the [OpenWeatherMap API](https://openweathermap.org/api) for fetching weather data based on location or city name. Key endpoints used:

- Get weather by city name:
  ```plaintext
  https://api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}

