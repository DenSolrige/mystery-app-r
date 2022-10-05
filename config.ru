# frozen_string_literal: true
require "bundler/setup"
require "hanami/api"
require "hanami/middleware/body_parser"
require 'securerandom'
# run below line in the command prompt to start up the api
# bundle exec rackup
use Hanami::Middleware::BodyParser, :json
class App < Hanami::API
    notes = []
    get "/" do
        "Hello, world"
    end

    post "/notes" do
        note = params[:content]
        notes.push(note)
        json({"index"=>notes.length-1,"content"=>note})
    end

    post "/notes/:index" do
        note = params[:content]
        index = Integer(params[:index])
        notes.insert(index,note)
        json({"index"=>index,"content"=>note})
    end

    get "/notes" do
        json(notes)
    end

    put "/notes/:index" do
        note = params[:content]
        index = Integer(params[:index])
        notes[index] = note
        json({"index"=>index,"content"=>note})
    end

    delete "/notes/:index" do
        index = Integer(params[:index])
        notes.delete_at(index)
        [204, ""]
    end

    post "/documents" do
        content = params[:content]
        docId = SecureRandom.uuid;
        File.write("#{docId}.txt", content)
        json({"docID"=>docId})
    end

    get "/documents/:docId" do
        docId = params[:docId]
        file_data = File.read("#{docId}.txt")
        json({"docID"=>docId,"content"=>file_data})
    end

    get "/math/:num1/:num2/:amount" do
        num1,num2,amount = params.values_at(:num1,:num2,:amount).map(&:to_i)
        starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        for i in 0..amount do
            num1*num2
        end
        ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        puts ending-starting
        json("Done")
    end

    memo = {}
    get "/factorial/:num" do
        num = Integer(params[:num])
        result = 1
        starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        if memo.has_key?(num)
            previousComputation = memo[num]
            ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
            puts ending-starting
            json({"previousComputation"=>previousComputation})
        else
            for i in 1..num do
                result *= i
            end
            ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
            puts ending-starting
            memo[num] = result
            json(result)
        end
    end

    get "/coordinates/:amount" do
        amount = Integer(params[:amount])
        coordinates = []
        for i in 0..amount-1 do
            lattitude = rand()*180-90
            longitude = rand()*360-180
            nsHemisphere = lattitude>0? "North": "South"
            ewHemisphere = longitude>0? "East": "West"
            coordinate = {
                "lattitude"=>lattitude,
                "longitude"=>longitude,
                "nsHemisphere"=>nsHemisphere,
                "ewHemisphere"=>ewHemisphere
            }
            coordinates.push(coordinate)
        end
        json(coordinates)
    end
end

run App.new