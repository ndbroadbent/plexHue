#!/usr/bin/ruby
require 'rubygems'
require 'json'
require 'httparty'

class Hue
    include HTTParty

    def initialize(config)
        $config = config

        # #Adding default values
        # if $config['hue']['starttransitiontime'].nil?
        #     $config['hue']['starttransitiontime'] = 30
        # end
        # if $config['hue']['pausedtransitiontime'].nil?
        #     $config['hue']['pausedtransitiontime'] = 30
        # end
        # if $config['hue']['stoptransitiontime'].nil?
        #     $config['hue']['stoptransitiontime'] = 30
        # end

        # self.class.base_uri "http://#{$config['hue']['hub_ip']}//"

        # if !self.class.get("api/plexHueUser")[0].nil?
        #     if self.class.get("api/plexHueUser")[0].keys[0] == 'error'
        #         response = self.class.post("api", :body => "{\"devicetype\":\"plexHue\",\"username\":\"plexHueUser\"}")

        #         if response[0].keys[0] == 'error'
        #             $logger.error("User not created.  Rerun and press link button")
        #             exit
        #         else
        #             $logger.info("User created.  Program is paired with hub")
        #         end
        #     end
        # end
        # self.class.base_uri "http://#{$config['hue']['hub_ip']}/api/plexHueUser//"
    end

    format :json

    def createGroup
        lights = self.class.get("lights")
        lightsPlex = []

        lights.each do | light |
            if $config['hue']['lights'].include? light[1]['name']
                lightsPlex.push(light[0])
            end
        end
        self.class.post("groups", :body => "{\"lights\": #{lightsPlex}, \"name\": \"plex\"}")
    end

    def deleteGroup
        groups = self.class.get("groups")

        groups.each do | group |
            if group[1]['name'] == 'plex'
                self.class.delete("groups/#{group[0]}")
            end
        end
    end

    def getPlexGroup
        groups = self.class.get("groups")

        groups.each do | group |
            if group[1]['name'] == 'plex'
                return group[0]
            end
        end
    end

    def transition(state)
        if state == 'playing'
            # self.class.put("groups/#{self.getPlexGroup}/action", :body => "{\"on\":true, \"alert\":\"none\", \"bri\":128, \"transitiontime\":#{$config['hue']['starttransitiontime']}}")
            $logger.info("Pausing Spotify and MPD...")
            system("su ndbroadbent -c \"DISPLAY=:0.0 dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Pause\"")
            system("mpc -P #{$config['mpc']['password']} pause")
        elsif state == 'paused'
 #           self.class.put("groups/#{self.getPlexGroup}/action", :body => "{\"on\":true, \"alert\":\"none\", \"bri\":200, \"transitiontime\":#{$config['hue']['pausedtransitiontime']}}")
	       #system("su ndbroadbent -c \"DISPLAY=:0.0 dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Play\"")
        elsif state == 'stopped'
  #          self.class.put("groups/#{self.getPlexGroup}/action", :body => "{\"on\":true, \"bri\":254, \"transitiontime\":#{$config['hue']['stoptransitiontime']}}")
	       #system("su ndbroadbent -c \"DISPLAY=:0.0 dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Play\"")
        end
    end
end
