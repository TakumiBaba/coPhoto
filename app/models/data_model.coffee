mongoose = require 'mongoose'
Schema   = mongoose.Schema

DataSchema = new Schema
  title:
    type: String
  content:
    type: String

ImageSchema = new Schema
	name:
		type: String
	url:
		type: String
	date:
		type: Number
	tagid:
		type: String
TitleSchema = new Schema
	name:
		type: String
	tag:
		type: String

# Data expression defines here.

# DataSchema.statics.findTest = (callback) ->
#   @find a, b, c, callback e, data ->

# Expression is available with...
#   {Data} = app.settings.models
#   Data.findTest (e, data) ->

module.exports =
  DataSchema: DataSchema
  Data: mongoose.model 'data', DataSchema

  ImageSchema: ImageSchema
  Image: mongoose.model 'image', ImageSchema

  TitleSchema: TitleSchema
  Title: mongoose.model 'title', TitleSchema