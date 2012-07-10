/*%%%%%
%% THQuery.m
%% Haters gonna hate
%% OpenSettings
%%
%% Created by theiostream on 13/5/2012
%%%%%*/

/*
-b bundle identifier for toggle
-t identifier for toggle
-i (on|off) image name for toggle
-e identifier for environment plist
-w theme identifier for environment plist
-n enabled toggles for environment
-h help
*/

static void usage() {
	fprintf(stderr, "Usage: thquery <option> [args]\n");
	fprintf(stderr, "\t-b: bundle identifier for 

int main(int argc, char** argv) {
	int c;
	char* key;
	
	if (argc < 2) {
		usage();
		goto end;
	}
	
	while ((c = getopt(argc, argv, "b:t:i:e:w:n:h") != -1) {
		switch (c) {
			case 'b':
				key = key_for_toggle(optarg, "CFBundleIdentifier");
				break;
			case 't':
				key = key_for_toggle(optarg, "THToggleIdentifier");
				break;
			case 'i':
				// meh