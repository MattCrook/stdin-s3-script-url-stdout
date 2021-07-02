package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"log"
	"os"
	"time"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
)


func buckets() (bucket_list []string) {
    // Initialize a session in us-east-1 that the SDK will use to load
    // credentials from the shared credentials file ~/.aws/credentials.
    sess, err := session.NewSession(&aws.Config{
        Region: aws.String("us-east-1")},
    )

    // Create S3 service client
    svc := s3.New(sess)

    result, err := svc.ListBuckets(nil)
    if err != nil {
        exitErrorf("Unable to list buckets, %v", err)
    }

    fmt.Println("Buckets:")

    for _, b := range result.Buckets {
        fmt.Printf("* %s created on %s\n",
            aws.StringValue(b.Name), aws.TimeValue(b.CreationDate))
            bucket_list = append(bucket_list, aws.StringValue(b.Name))
    }

    return bucket_list
}

func bucket_acl(bucket_name string) {
    // if len(os.Args) != 2 {
    //     exitErrorf("Bucket name required\nUsage: go run", os.Args[0], "BUCKET")
    // }

    // bucket := os.Args[1]
    bucket := bucket_name

    // Initialize a session that loads credentials from the shared credentials file ~/.aws/credentials
    // and the region from the shared configuration file ~/.aws/config.
    // sess := session.Must(session.NewSessionWithOptions(session.Options{
    //     SharedConfigState: session.SharedConfigEnable,
    // }))

    sess, err := session.NewSession(&aws.Config{
        Region: aws.String("us-east-1")},
    )

    if err != nil {
        // Special error handling for the when the bucket doesn't
        // exists so we can give a more direct error message from the CLI.
        if aerr, ok := err.(awserr.Error); ok {
            switch aerr.Code() {
            case s3.ErrCodeNoSuchBucket:
                exitErrorf("Bucket %q does not exist.", bucket)
            case "NoSuchBucketPolicy":
                exitErrorf("Bucket %q does not have a policy.", bucket)
            }
        }
        exitErrorf("Unable to get bucket %q policy, %v.", bucket, err)
    }

    // Create S3 service client
    svc := s3.New(sess)

    // Get bucket ACL
    result, err := svc.GetBucketAcl(&s3.GetBucketAclInput{Bucket: &bucket})
    if err != nil {
        exitErrorf(err.Error())
    }

    fmt.Println("Owner:", *result.Owner.DisplayName)
    fmt.Println("")
    fmt.Println("Grants")

    for _, g := range result.Grants {
        // If we add a canned ACL, the name is nil
        if g.Grantee.DisplayName == nil {
            fmt.Println("  Grantee:    EVERYONE")
        } else {
            fmt.Println("  Grantee:   ", *g.Grantee.DisplayName)
        }

        fmt.Println("  Type:      ", *g.Grantee.Type)
        fmt.Println("  Permission:", *g.Permission)
        fmt.Println("")
    }
}


func bucket_policy(bucket_name string) {
    // if len(os.Args) != 2 {
    //     exitErrorf("bucket name required\nUsage: %s bucket_name",
    //         filepath.Base(os.Args[0]))
    // }

    bucket := bucket_name

    // Initialize a session in us-west-2 that the SDK will use to load
    // credentials from the shared credentials file ~/.aws/credentials.
    sess, err := session.NewSession(&aws.Config{
        Region: aws.String("us-east-1")},
    )

    if err != nil {
        // Special error handling for the when the bucket doesn't
        // exists so we can give a more direct error message from the CLI.
        if aerr, ok := err.(awserr.Error); ok {
            switch aerr.Code() {
            case s3.ErrCodeNoSuchBucket:
                exitErrorf("Bucket %q does not exist.", bucket)
            case "NoSuchBucketPolicy":
                exitErrorf("Bucket %q does not have a policy.", bucket)
            }
        }
        exitErrorf("Unable to get bucket %q policy, %v.", bucket, err)
    }

    // Create S3 service client
    svc := s3.New(sess)

    // Call S3 to retrieve the policy for the selected bucket.
    result, err := svc.GetBucketPolicy(&s3.GetBucketPolicyInput{
        Bucket: aws.String(bucket),
    })
    if err != nil {
        // Special error handling for the when the bucket doesn't
        // exists so we can give a more direct error message from the CLI.
        if aerr, ok := err.(awserr.Error); ok {
            switch aerr.Code() {
            case s3.ErrCodeNoSuchBucket:
                exitErrorf("Bucket %q does not exist.", bucket)
            case "NoSuchBucketPolicy":
                exitErrorf("Bucket %q does not have a policy.", bucket)
            }
        }
        exitErrorf("Unable to get bucket %q policy, %v.", bucket, err)
    }

    out := bytes.Buffer{}
    policyStr := aws.StringValue(result.Policy)
    if err := json.Indent(&out, []byte(policyStr), "", "  "); err != nil {
        exitErrorf("Failed to pretty print bucket policy, %v.", err)
    }

    fmt.Printf("%q's Bucket Policy:\n", bucket)
    fmt.Println(out.String())
}


// Downloads an item from an S3 Bucket
//
// Usage:
//    go run s3_download.go
func main() {
    // Initialize a session in us-west-1 that the SDK will use to load
    // credentials from the shared credentials file ~/.aws/credentials.
    sess, err := session.NewSession(&aws.Config{
        Region: aws.String("us-east-1")},
    )

    // Create S3 service client
    svc := s3.New(sess)

    bucket_name := buckets()
    fmt.Println("BUCKETS", buckets())


    bucket_acl(bucket_name[0])
    bucket_policy(bucket_name[0])

    req, _ := svc.GetObjectRequest(&s3.GetObjectInput{
        Bucket: aws.String("myBucket"),
        Key:    aws.String("myKey"),
    })
    urlStr, err := req.Presign(15 * time.Minute)

    if err != nil {
        log.Println("Failed to sign request", err)
    }

    log.Println("The URL is", urlStr)
}

func exitErrorf(msg string, args ...interface{}) {
    fmt.Fprintf(os.Stderr, msg+"\n", args...)
    os.Exit(1)
}
