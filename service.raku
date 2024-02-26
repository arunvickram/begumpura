use Cro::HTTP::Log::File;
use Cro::HTTP::Server;
use Red:api<2>;
use Models::User;
use Models::Post;
use Routes;

red-defaults default => database("SQLite", :database<tmp/test.sqlite>);
# red-defaults default => database("Pg", :host<localhost>, :database<begumpura_db>)

User.^create-table:        :if-not-exists;
UserSession.^create-table: :if-not-exists;
Post.^create-table:        :if-not-exists;
# Tag.^create-table:     :if-not-exists;
# PostTag.^create-table: :if-not-exists;

my Cro::Service $http = Cro::HTTP::Server.new(
    http => <1.1>,
    host => %*ENV<BEGUMPURA_HOST> ||
        die("Missing BEGUMPURA_HOST in environment"),
    port => %*ENV<BEGUMPURA_PORT> ||
        die("Missing BEGUMPURA_PORT in environment"),
    application => routes(),
    after => [
        Cro::HTTP::Log::File.new(logs => $*OUT, errors => $*ERR)
    ]
);
$http.start;
say "Listening at http://%*ENV<BEGUMPURA_HOST>:%*ENV<BEGUMPURA_PORT>";
react {
    whenever signal(SIGINT) {
        say "Shutting down...";
        $http.stop;
        done;
    }
}
