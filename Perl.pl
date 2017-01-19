use v5.20;
use warnings;

use DBI;
use DBD::ODBC;

my $host = '192.168.23.128';
my $user = 'dbc';
my $pass = 'dbc';
#   DBCName Hostname
#   UID     User ID
#   PWD     Password
my $connection_string = "Driver={Teradata};DBCName=$host;UID=$user;PWD=$pass";

# Connect
my $connection = DBI->connect("dbi:ODBC:$connection_string")
or die " Connect failed: " . DBI->errstr;

# Prepare and execute statement
my $statement = $connection->prepare("SELECT TABLENAME FROM DBC.TABLES WHERE TABLEKIND = 'T' ORDER BY TABLENAME")
or die 'Statement preparation failed: ' . DBI->errstr;

$statement->execute or die 'Statement execution failed: ' . DBI->errstr;

# Fetch rows
while (my $row = $statement->fetchrow_arrayref()) {
    say '[', join('|', map { (defined $_) ? $_ : 'NULL' } @$row), ']';
}

# Clean up
$statement->finish;
$connection->disconnect;
