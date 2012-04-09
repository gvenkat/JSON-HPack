package JSON::HPack;

use common::sense;
use constant FIRST => 0;
use JSON::Any;

our $VERSION = q(0.0.1);


=head1 NAME 

JSON-HPack - A simple and fast JSON packer

=head1 SYNOPSIS

  use JSON::HPack; 

  JSON::HPack->pack( [ 
    {
      name => 'Larry Wall',
      nick  => 'timtowtdi' 
    }
  ] );

  # - OR -

  JSON::HPack->dump( [
    {
      name => 'Larry Wall',
      nick  => 'timtowtdi' 
    }
  ] )

  # To Unpack
  JSON::HPack->unpack(
    [ 2, 'name', 'nick', 'Larry Wall', 'timtowdi' ]
  )

  # - OR use JSON string directly
  JSON::HPack->load( $json_string )

=head1 DESCRIPTION

=cut

sub pack {
  my ( $class, $aoh ) = @_;

  my %first     = %{ $aoh->[FIRST] };
  my $key_size  = scalar( keys( %first ) );
  my @keys      = keys( %first );

  [
    $key_size,
    @keys, 
    map {
      my $this = $_;
      map {
        $this->{$_}
      } @keys
    } @{ $aoh }[ 0 .. ( scalar( @$aoh ) - 1 ) ] 
  ];

}

sub unpack {
  my ( $class, $pa ) = @_;

  my ( $results, @keys )  = ( 
    [ ],
    @{ $pa }[ 1 .. $pa->[ FIRST ] ]
  );

  my ( $start, $length ) = ( scalar( @keys ) ) x 2;

  LOOP: while( ( $start + 1 + $length ) <= @$pa ) {
    my @values = @{ $pa }[ $start + 1 .. ( $start + $length ) ];

    my %hash = (
      map {
       $keys[ $_ ] => $values[ $_ ] 
      } ( 0 .. ( $length - 1 ) ) 
    );

    push( @$results, { %hash } );

    $start += $length;
  }

  $results;

}


sub load {
  my ( $class, $string ) = @_;

  $class->unpack( 
    JSON::Any
      ->new
      ->jsonToObj( $string )
  );
}

sub dump {
  my ( $class, $struct ) = @_;

  JSON::Any->new
    ->objToJson(
      $class->pack( $struct )
    );

}




1;
__END__
