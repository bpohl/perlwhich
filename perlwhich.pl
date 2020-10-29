#!/usr/bin/perl
# perlwhich
# $Id$
# $Revision$
# $Tags$
#
# The Three Laws of Robotics
# 1. A robot may not injure a human being or, through inaction,
#    allow a human being to come to harm.
# 2. A robot must obey orders given it by human beings except
#    where such orders would conflict with the First Law.
# 3. A robot must protect its own existence as long as such
#    protection does not conflict with the First or Second Law.
#                                               -- Isaac Asimov
#

# Description:
#
# Look for a loadable Perl module in the @INC path.
#

# List of posible extensions for Perl files
use constant PERL_EXTENSIONS => (".pm", ".pl", "");

# Make variables of the color escape sequences.
#   If colors are not available or STDOUT not a tty
#   then the vars are empty.
use constant COLORS    => qw( red     yellow green blue
                              magenta cyan   black white  
                              reset                      );
use vars map("\$$_",&COLORS);

unless($ARGV[0] eq "--nocolor"){
    if( -t STDOUT || ($ARGV[0] eq "--color") ){
        eval "use Term::ANSIColor;";
        unless($@){ eval("\$$_ = color('$_');") foreach &COLORS; }
    }
    #print eval("\$$_")."$_ " foreach &COLORS; print "$reset\n";
}
$ARGV[0] =~ m/^--/ && shift;

# Print usage if no arguments.
unless(@ARGV){
    warn "${cyan}Usage:${reset} ".__FILE__." ${yellow}[--[no]color]".
           " ${white}[MODULE_NAME [MODULE_NAME ...]]${reset}\n";
    exit 1;
}

# For each module named, try to 'use' it and if it works display its
#   location from %INC.  If it isn't loaded then display the error which
#   has the @INC searched.
my @modules = ();
my $incs = undef;
while(my $module = shift){

    eval "use $module;";
    if($@ =~ s/BEGIN failed--compilation aborted .*?\n//ig){
        $@ =~ s/^(Can\'t\slocate)(\s.*?\s)(in\s\@INC\s)(.*)
                \(\@INC\scontains:\s*(.*)\)\s*at\s\(eval\s.*?$
                               /${magenta}$1${red}$2${magenta}$3${reset}$4/x;
        $incs = $5;
        warn $@;
    }elsif($@){
        warn "${magenta}Error loading ${red}$module${magenta}:${reset} $@";
    }else{
        (my $file = $module) =~ s/::/\//g;
        ($file) = grep {$_} @INC{ map { "${file}$_" } &PERL_EXTENSIONS };
        push(@modules, [$module, $file, eval("\${${module}::VERSION};")]);
    }
}
# join("\n".(" "x16), @INC)
print "(\@INC contains: ${green}", join(" ", @INC), "${reset})\n" if($incs);

# Calculate the max length of each column
sub column_width {
    my ($column) = @_;
    return (sort { $a <=> $b } (map {length($_->[ $column ])} @modules))[-1];
}
my @width = (length("${blue}: ") + column_width(0),
             column_width(1), column_width(2)      );

# Format output
foreach my $module (@modules){
    printf("${cyan}%-${width[0]}s${reset}%-${width[1]}s "
           . "${magenta}(vers: ${red}%${width[2]}s${magenta})${reset}\n",
           $module->[0]."${blue}: ", @$module[1,2]                       );
}

exit 0;
