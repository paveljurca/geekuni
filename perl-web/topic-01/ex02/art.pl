#!/usr/bin/perl

use Dancer2;

get '/' => sub {
  return "<h1>Hello World!</h1>";
};

dance;

