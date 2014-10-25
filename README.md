# Cursorquery

<pre>
            ___
           /  /\
          /  /  \
         /  /    \
        /  /  /\  \
       /  /  /  \  \
      /  /  /    \  \
     /  /  /  /\  \  \
    /  /  /  /\ \  \  \
   /  /  /  /  \ \  \  \
  /  /  /__/____\ \  \  \
 /  /____________\ \  \  \
/___________________\  \  /
\_______________________\/
</pre>

Create cursored queries for raipidly changing data with Active Record.
Useful for APIs making requests where a feed is constantly updating.

## Installation

Add this line to your application's Gemfile:

    gem 'cursorquery'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cursorquery

## Usage

Call the method cursor on any ActiveRecord query, passing in params.

    Post.all.cursor(params)

Initial query returns a default amount of records (which can be overriden with
the page_size param) and a unique identifier "etag". Pass etag back to
subsequent queries along with previous and/or latest params. It will return
new and/or older records based on the previous query, along with arrays of
updated and deleted records.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/cursorquery/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
