package JSON::HPack;

use common::sense;
use constant FIRST => 0;
use JSON::Any;

our $VERSION = q(0.0.1);

sub pack {
  my ( $class, $aoh ) = @_;

  my %first = %{ $aoh->[FIRST] };
  my ( @keys, $key_size ) = ( keys( %first ), scalar( keys( %first ) ) );

  [
    $key_size,
    @keys, 
    map {
      values( %$_ )
    } @{ $aoh }[ $key_size .. scalar( @$aoh ) ] 
  ];

}

sub unpack {
  my ( $class, $pa ) = @_;

  my ( $results, @keys )  = ( 
    [ ],
    @{ $pa }[ 1 .. $pa->[ FIRST ] ]
  );

  my ( $start, $length ) = ( scalar( @keys ) ) x 2;

  LOOP: while( $start < @$pa ) {
    my @values = @{ $pa }[ $start .. ( $start + $length ) ];
    my %hash = (
      map {
       $keys[ $_ ] => $values[ $_ ] 
      } ( 0 .. $length ) 
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
