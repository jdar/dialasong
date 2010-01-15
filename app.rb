require 'rubygems'
require 'sinatra'
require 'builder'

=begin
  This simple script demonstrates building custom XML for twilio voice-apps. (according to "TwiML" proprietary open specification)

  Possible exercises for the reader:
    1) pressing any key during a song to return to the main menu
    2) understanding mp3 caching (i.e., why am I using a 'get' for the 'play' command, rather than a 'post')
    3) pressing any key during a song to rate the song, and continue playing (requires adding a data storage component. Flatfile?)
    4) have the system hang up with a polite message
    5) have the system record a user singing a lyric, then string them together
    6) separate the intro jingle/instructions from the actual menu that gets repeated.
    7) change the voice (to 'woman')
    8) have the system call you back
    9) get a feed notification of who is calling this number through the twilio regular API 
    
  Background info and a similar Rails script available at:
  http://dariusroberts.com/posts/dial-a-song-sinatra-twilio-to-reproduce-tmbg-cult-project

=end


SONG_URLS = [
    "http://dariusroberts.com/songs/Istanbul%20(Not%20Constantinople).mp3",
    "http://dariusroberts.com/songs/Birdhouse%20In%20Your%20Soul.mp3",
    "http://dariusroberts.com/songs/impressed.mp3",
    "http://dariusroberts.com/songs/Ana%20Ng.mp3",
    "http://dariusroberts.com/songs/Whistling%20In%20The%20Dark.mp3"
  ]


post '/songs' do
  builder do |xml|
    xml.Response do
      # intro to service
      tmbg_name = "http://dariusroberts.com/songs/They%20Might%20Be%20Giants2.mp3"
      2.times { xml.Play tmbg_name }
      
      xml.Gather(:action => '/play', :numDigits => 1, :method=>'GET') do        
        # list options        
        xml.Say ' You have dialed Dial-A-Song! You win! A song! Listen carefully and press 9 at any time to repeat this menu.'
        xml.Say ' Press 1 to play "Istanbul (Not Constantinople)"'
        xml.Say ' 2 for "Birdhouse in your soul"'
        xml.Say ' 3 for "I\'m Impressed"'
        xml.Say ' 4 for "Ana Ng"'
        xml.Say ' 5 for "Whistling in the Dark"'
        xml.Say 'Or press 10 to repeat this menu in two-step time'
        xml.Pause
        xml.Say 'Just kidding. Pressing 10 won\'t work at all.'
      end
      xml.Redirect '/songs'
    end
  end
end

get '/play' do
  # PSYCH. repeat songs menu
  case song_number = params['Digits'].to_i
  when 1..5
    # find and play a song
    song_url = SONG_URLS[song_number - 1]
    
    builder do |xml|
       xml.instruct!
       xml.Response do
         xml.comment! "Dial-a-song Twilio tutorial by darius.roberts"
         xml.Play song_url
       end
     end
    
   else
       builder do |xml|
         xml.instruct!
         xml.Response do
           xml.Redirect '/songs'
         end
       end     
   end
end

