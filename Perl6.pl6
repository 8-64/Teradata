use v6;

if ($*DISTRO.is-win) {
    %*ENV<DBDISH_ODBC_LIB> = 'C:\Windows\System32\odbc32';
}

use DBIish;
use DBDish::ODBC;

my $host = '192.168.23.128';
my $user = 'dbc';
my $pass = 'dbc';
#   DBCName Hostname
#   UID     User ID
#   PWD     Password
my $connection_string = "Driver=\{Teradata\};DBCName=$host;UID=$user;PWD=$pass";

# Connect
my $connection = DBIish.connect('ODBC', :conn-str($connection_string));

# Prepare and execute statement
my $statement = $connection.prepare("SELECT TABLENAME FROM DBC.TABLES WHERE TABLEKIND = 'T' ORDER BY TABLENAME");
$statement.execute;

# Fetch rows
while (my $row = $statement.fetchrow_arrayref) {
    say '[',  @$row.map({ .defined ?? $_ !! 'NULL' }).join('|') , ']';
}

# Clean up
$statement.finish;
$connection.dispose;
