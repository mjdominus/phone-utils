use ExtUtils::MakeMaker;
WriteMakefile
  (
   NAME => "PhoneUtils",
   PREREQ_PM => {
		 'Email::Simple' => 0,
		 'Getopt::Std' => 0,
		},
  );
