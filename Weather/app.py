import streamlit as st
import requests

# API Configuration
API_KEY = "57e00c15d85b13d67a6f52afdd0f3377"  # Replace with your OpenWeatherMap API key
BASE_URL = "http://api.openweathermap.org/data/2.5/weather"

# App Title
st.title("🌤️ Weather Finder")

# User Input for City Name
city = st.text_input("Enter the city name:")

# Function to fetch weather data
def get_weather(city):
    try:
        # Make the API call
        params = {
            'q': city,
            'appid': API_KEY,
            'units': 'metric'  # To get temperature in Celsius
        }
        response = requests.get(BASE_URL, params=params)
        data = response.json()

        if response.status_code == 200:
            return data
        else:
            st.error("City not found! Please check the spelling.")
            return None
    except:
        st.error("Unable to fetch data. Please try again later.")
        return None

# Function to get weather icon based on condition
def get_weather_icon(condition):
    icons = {
        'Clear': '☀️',
        'Clouds': '☁️',
        'Rain': '🌧️',
        'Drizzle': '🌦️',
        'Thunderstorm': '⛈️',
        'Snow': '❄️',
        'Mist': '🌫️',
        'Smoke': '🌫️',
        'Haze': '🌫️',
        'Dust': '🌫️',
        'Fog': '🌫️',
    }
    return icons.get(condition, '🌈')

# Show the weather data when the button is clicked
if city:
    weather_data = get_weather(city)
    
    if weather_data:
        # Extract weather details
        temp = weather_data['main']['temp']
        humidity = weather_data['main']['humidity']
        description = weather_data['weather'][0]['description']
        main_weather = weather_data['weather'][0]['main']
        
        # Get weather icon
        icon = get_weather_icon(main_weather)
        
        # Display weather data with icon
        st.write(f"**Weather Icon:** {icon}")
        st.write(f"**Temperature:** {temp}°C")
        st.write(f"**Humidity:** {humidity}%")
        st.write(f"**Description:** {description.title()}")
