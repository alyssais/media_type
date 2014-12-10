# MediaType

A tiny library for parsing and generating Internet Media Types (AKA MIME types).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'media_type'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install media_type

## Usage

### Parsing a Media Type

```ruby
media_type = MediaType.parse("application/vnd.adobe.xdp+xml; charset=utf-8")
media_type.type #=> "application"
media_type.tree #=> "vendor"
media_type.subtype #=> "adobe.xdp"
media_type.suffix #=> "xml"
media_type.parameters #=> {"charset"=>"utf-8"}
```

To disable parameter parsing and leave the parameters as a string,
set the `parse_parameters` option to `false`:

```ruby
media_type = MediaType.parse("text/plain; charset=US-ASCII", parse_parameters: false)
media_type.parameters #=> " charset=US-ASCII"
```

### Generating a Media Type

```ruby
media_type = MediaType.new
media_type.type = "application"
media_type.tree = "vendor"
media_type.subtype = "adobe.xdp"
media_type.suffix = "xml"
media_type.parameters = { "charset" => "utf-8" }
media_type.to_s #=> "application/vnd.adobe.xdp+xml; charset=utf-8"
```

### Comparing Media Types

The `MediaType` class allows you to check whether two media types are
*semantically equal*, even if they aren't equal strings.

```ruby
type1 = MediaType.parse('text/html; charset="utf-8"')
type2 = MediaType.parse('text/html; charset=utf-8')
type1 == type2 #=> true
```

## Contributing

1. [Fork it](https://github.com/[my-github-username]/media_type/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

---

[ ![Codeship Status for alyssais/media_type](https://codeship.com/projects/36ec2d70-622e-0132-f3b2-3a888924fd85/status)](https://codeship.com/projects/52003)
