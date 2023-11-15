# The Movies
A Flutter app to display upcoming movies from TMDB

It is an app that lists all upcoming movies using The Movie Db API (TMdb) and then navigates to book movie tickets.

# APK Download
Link to the apk file: <a href="https://raw.githubusercontent.com/anees4ever/the-movies/main/the_movie_app.apk" >The Movie App</a>

# Video Demo
Link to the video: <a href="https://raw.githubusercontent.com/anees4ever/the-movies/main/screenshots/screen_recording.mp4" >Video Link</a>

# Screenshots
<!-- TABLE_GENERATE_START -->
| Home  | Search - Genres | Search - Searching | Search - Result | Movie Details | Shows | Booking |
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
| <img src="https://raw.githubusercontent.com/anees4ever/the-movies/main/screenshots/screenshot_home.png" width="200" /> | <img src="https://raw.githubusercontent.com/anees4ever/the-movies/main/screenshots/screenshot_search_1.png" width="200" /> | <img src="https://raw.githubusercontent.com/anees4ever/the-movies/main/screenshots/screenshot_search_2.png" width="200" /> | <img src="https://raw.githubusercontent.com/anees4ever/the-movies/main/screenshots/screenshot_search_3.png" width="200" /> | <img src="https://raw.githubusercontent.com/anees4ever/the-movies/main/screenshots/screenshot_movie_details.png" width="200" /> | <img src="https://raw.githubusercontent.com/anees4ever/the-movies/main/screenshots/screenshot_show_times.png" width="200" /> | <img src="https://raw.githubusercontent.com/anees4ever/the-movies/main/screenshots/screenshot_booking.png" width="200" /> |
<!-- TABLE_GENERATE_END -->




# Movie List Screen: List down all upcoming movies on the list 					
Movie List API: https://api.themoviedb.org/3/movie/upcoming

Params: api_key - 123456abcdefg (dummy, you can create your one key for free please refer to the themoviedb documentation).
								
# Movie Detail Screen: 
When a user selects any movie from the movie list screen, it navigates to the Movie detail screen. After pressing the “​Watch Trailer​” button on the movie details screen, the application displays a full-screen movie player and automatically starts the playback (to get the needed URLs to use the “movie/#MOVIE_ID#/videos” API call). After the trailer is finished the player will be automatically closed, and the app returns to the detail page. The playback can be also canceled by pressing the “Done” button.


Movie Details API: https://api.themoviedb.org/3/movie/<movie-id>
Params: api_key - 123456abcdefg (dummy)
								
Get Images API: https://api.themoviedb.org/3/movie/<movie-id>/images
Params: api_key - 123456abcdefg (dummy)

# Movie search screen 

# Seat mapping(UI only)
