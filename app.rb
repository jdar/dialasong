require 'rubygems'
require 'sinatra'
require 'builder'

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
        xml.Say ' You have dialed Dial-A-Song! You win! A song! Listen carefully and press 9 at any time to repeat this menu.', :voice=>'woman'
        
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
  # PSYCH repeat songs menu
  case song_number = params['Digits'].to_i
  when 1..5
    # find and play a song
    song_url = SONG_URLS[song_number - 1]
    
    builder do |xml|
       xml.instruct!
       xml.Response do
         xml.Gather(:action => '/songs', :numDigits => 1, :method=>'POST') do        
          xml.comment! "Dial-a-song Twilio tutorial by darius.roberts"
          xml.Play song_url
        end
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




