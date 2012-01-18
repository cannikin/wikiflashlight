require 'sinatra'
require 'open-uri'

get '/*' do
  response = open("http://en.wikipedia.org/#{params[:splat].first}?#{request.query_string}")
  output = response.read + %q{<script type="text/javascript">$(document).ready(function() { $('body').append('<div style="position:fixed;top:0;left:0;padding:0.5em 1em;font-size:12px;background-color:#000000;color:#ffffff">Revealed by WikiFlashlight!</div>') });</script>}
  filename = File.join('public',params[:splat].first)

  # save the page locally for speedier future requests
  if request.query_string == '' and filename != 'public/wiki/Special:Random'
    begin
      if filename == 'public/'
        filename = File.join('public','index')
      end
      filename += '.html' unless filename.match(/\./)
      FileUtils.mkdir_p(File.dirname(filename))
      file = File.new(filename, 'w')
      file.write(output)
    ensure
      file.close
    end
  end
  return output
end
