## Testing Locally 
1. Specify correct AWS profile and valid path to AWS credentials file (Usually located at ~/.aws/credentials). It's recommended to create a sandbox AWS account separate from any production accounts where the module tests will deploy resources into.   
2. Run cd test/ && go test -v -timeout 30m