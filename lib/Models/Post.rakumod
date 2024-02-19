use v6.d;
use Red:api<2>;

# model PostTag {...}

model Post is table<posts> is rw {
  has Int      $.id        is serial;
  has Str      $.title     is column;
  # has          $!author-id is referencing( *.id, :model<User>, :require<Models::User> );
  has Str      $.body      is column;
  # has          $.author    is relationship( *.author-id, :model<User>, :require<Models::User> );
  # has PostTag  @.post-tags is relationship{ .post-id };
  # has Bool     $.deleted   is column = False;
  # has DateTime $.created   is column .= now;

  # method tags { @.post-tags>>.tag }
}

# model Tag is table<tags> is export {
#   has Str $.name is id;
#   has PostTag @.post-tags is relationship{ .tag-id };

#   method posts { @.post-tags>>.post }
# }

# model PostTag is table<post_tag> {
#   has UInt $.post-id is referencing( *.id , :model(Post) ) is id;
#   has Str  $.tag-id  is referencing( *.name, :model(Tag) ) is id;
#   has Post $.post    is relationship{ .post-id };
#   has Tag  $.tag     is relationship{ .tag-id };
# }
