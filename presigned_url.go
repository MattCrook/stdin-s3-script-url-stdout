package main

import (
	"flag"
	"fmt"
	"time"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
)


func GetPresignedURL(sess *session.Session, bucket, key, role *string) (string, error) {
	svc := s3.New(sess)

    req, _ := svc.GetObjectRequest(&s3.GetObjectInput{
        Bucket: bucket,
        Key:    key,
    })

    urlStr, err := req.Presign(15 * time.Minute)
    if err != nil {
        return "", err
    }

    return urlStr, nil
}

func main() {
    bucket := flag.String("b", "", "The bucket")
    key := flag.String("k", "", "The object key")
    role := flag.String("r", "", "The name IAM role to execute the script with")
    flag.Parse()

    if *bucket == "" || *key == "" || *role == ""{
        fmt.Println("You must supply a bucket name (-b BUCKET) and object key (-k KEY) and the iam role to execute the script (-r ROLE)")
        return
    }

    sess := session.Must(session.NewSessionWithOptions(session.Options{
        SharedConfigState: session.SharedConfigEnable,
        //Profile: *source_profile,
        Config: aws.Config{
            Region: aws.String("us-east-1"),
        },
	}))

    urlStr, err := GetPresignedURL(sess, bucket, key, role)
    if err != nil {
        fmt.Println("Got an error retrieving a presigned URL:")
        fmt.Println(err)
        return
    }

    fmt.Println("The presigned URL: " + urlStr + " is valid for 15 minutes")
}
