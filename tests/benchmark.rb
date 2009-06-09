# coding: utf-8
require File.join(File.dirname(__FILE__),"..","lib","pinyin.rb")
require 'benchmark'

chinese = %w(中华人民共和国 我们 你好)

Benchmark.bmbm do |x|
  x.report("Pinyin") do
    10000.times do
      chinese.map {|x| Chinese::Pronunciation.to_pinyin(x)}
    end
  end
end
