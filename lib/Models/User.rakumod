use v6.d;
use Red:api<2>;
use Crypt::Argon2;
use Cro::HTTP::Auth;
use Cro::HTTP::Session::Red;

model User is export is table<users> {
  also is rw;

  has Int $.id              is serial;
  has Str $.email           is column{ :unique };
  has Str $.hashed-password is column;
  # has     @.posts is relationship( *.author-id, :model<Post>, :require<Model::Post> );

  # method active-posts { @!posts.grep: not *.deleted }
  method check-password(Str $password --> Bool) { argon2-verify($.hashed-password, $password) }
}

model UserSession is table<user_session> does Cro::HTTP::Auth is export {
  has Str  $.id         is id;
  has UInt $.uid        is referencing(*.id, :model(User));
  has User $.user       is relationship{ .uid } is rw;
}