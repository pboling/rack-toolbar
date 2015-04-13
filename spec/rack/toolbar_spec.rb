describe Rack::Toolbar do

  it "has a version number" do
    expect(Rack::Toolbar::VERSION).not_to be nil
  end

  context "request" do
    def app(*args)
      Rack::Builder.new do
        use Rack::Toolbar, *args
        run lambda { |env| [200, {"Content-Type" => "text/html"}, ["<html><head></head><body><h1>Important</h1></body></html>"]] }
      end
    end

    it "inserts into the response" do
      response = Rack::MockRequest.new(app).get("/")
      expect(response.body).to eq "<html><head></head><body><h1>Important</h1>  <h1>Welcome to rack-toolbar</h1>\n  <ul>\n    <li>Define render in Middleware subclass of Rack::Toolbar to return an HTML snippet.</li>\n    <li>or</li>\n    <li>Pass an HTML snippet as an argument and use Rack::Toolbar directly: Rack::Toolbar.new(snippet).</li>\n    <li>or</li>\n    <li>Redefine Rack::Toolbar::SNIPPET and ignore with the warnings.</li>\n  </ul>\n</body></html>"
    end

    context "via use" do
      it "Allows customization of snippet" do
        response = Rack::MockRequest.new(app({:snippet => "<p>Custom</p>"})).get("/")
        expect(response.body).to eq "<html><head></head><body><h1>Important</h1><p>Custom</p></body></html>"
      end
      it "Allows customization of insertion point" do
        response = Rack::MockRequest.new(app(:snippet => %[<meta charset="utf-8">], :insertion_point => "</head>")).get("/")
        expect(response.body).to eq %[<html><head><meta charset="utf-8"></head><body><h1>Important</h1></body></html>]
      end
      it "Allows customization of insertion method" do
        response = Rack::MockRequest.new(app(:snippet => %[<script>javascript:void(0)</script>], :insertion_method => :after)).get("/")
        expect(response.body).to eq %[<html><head></head><body><h1>Important</h1></body><script>javascript:void(0)</script></html>]
      end
    end

    context "via subclass" do
      it "Allows customization" do
        class SubclassOfRackToolbar < Rack::Toolbar
          def render
            "<p>Custom Render</p>"
          end
        end
        app_using_subclass = Rack::Builder.new do
          use SubclassOfRackToolbar
          run lambda { |env| [200, {"Content-Type" => "text/html"}, ["<html><head></head><body><h1>Important</h1></body></html>"]] }
        end

        response = Rack::MockRequest.new(app_using_subclass).get("/")
        expect(response.body).to eq "<html><head></head><body><h1>Important</h1><p>Custom Render</p></body></html>"
      end
      it "works with custom INSERTION_POINT" do
        class SomeClass < Rack::Toolbar
          INSERTION_POINT = "</head>"
          def render
            %[<meta charset="utf-8">]
          end
        end
        app_using_subclass = Rack::Builder.new do
          use SomeClass
          run lambda { |env| [200, {"Content-Type" => "text/html"}, ["<html><head></head><body><h1>Important</h1></body></html>"]] }
        end

        response = Rack::MockRequest.new(app_using_subclass).get("/")
        expect(response.body).to eq %[<html><head><meta charset="utf-8"></head><body><h1>Important</h1></body></html>]
      end
      it "works with custom INSERTION_METHOD" do
        class OtherClass < Rack::Toolbar
          INSERTION_METHOD = :after
          INSERTION_POINT = "<body>"
          def render
            %[<div>Injected</div>]
          end
        end
        app_using_subclass = Rack::Builder.new do
          use OtherClass
          run lambda { |env| [200, {"Content-Type" => "text/html"}, ["<html><head></head><body><h1>Important</h1></body></html>"]] }
        end

        response = Rack::MockRequest.new(app_using_subclass).get("/")
        expect(response.body).to eq %[<html><head></head><body><div>Injected</div><h1>Important</h1></body></html>]
      end
      context "use with options" do
        class CustomClass < Rack::Toolbar
          INSERTION_METHOD = :after
          INSERTION_POINT = "<body>"
          def render
            %[<div>Injected</div>]
          end
        end

        it "Ignores customization of snippet" do
          app_using_subclass = Rack::Builder.new do
            use CustomClass, :snippet => "<p>Custom</p>"
            run lambda { |env| [200, {"Content-Type" => "text/html"}, ["<html><head></head><body><h1>Important</h1></body></html>"]] }
          end
          response = Rack::MockRequest.new(app_using_subclass).get("/")
          expect(response.body).to eq "<html><head></head><body><div>Injected</div><h1>Important</h1></body></html>"
        end
        it "Allows customization of insertion point" do
          app_using_subclass = Rack::Builder.new do
            use CustomClass, :insertion_point => "</body>"
            run lambda { |env| [200, {"Content-Type" => "text/html"}, ["<html><head></head><body><h1>Important</h1></body></html>"]] }
          end
          response = Rack::MockRequest.new(app_using_subclass).get("/")
          expect(response.body).to eq %[<html><head></head><body><h1>Important</h1></body><div>Injected</div></html>]
        end
        it "Allows customization of insertion method" do
          app_using_subclass = Rack::Builder.new do
            use CustomClass, :insertion_method => :before
            run lambda { |env| [200, {"Content-Type" => "text/html"}, ["<html><head></head><body><h1>Important</h1></body></html>"]] }
          end
          response = Rack::MockRequest.new(app_using_subclass).get("/")
          expect(response.body).to eq %[<html><head></head><div>Injected</div><body><h1>Important</h1></body></html>]
        end
      end

    end

  end
end
