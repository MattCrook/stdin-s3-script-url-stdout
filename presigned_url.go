package main

// snippet-start:[s3.go.generate_presigned_url.imports]
import (
	"flag"
	"fmt"
	"time"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
)


func GetPresignedURL(sess *session.Session, bucket, key, iam_role *string) (string, error) {
    // snippet-start:[s3.go.generate_presigned_url.call]
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String("us-east-1")},
    )
	svc := s3.New(sess)

    req, _ := svc.GetObjectRequest(&s3.GetObjectInput{
        Bucket: bucket,
        Key:    key,
    })

    urlStr, err := req.Presign(15 * time.Minute)
    // snippet-end:[s3.go.generate_presigned_url.call]
    if err != nil {
        return "", err
    }

    return urlStr, nil
}

func main() {
    // snippet-start:[s3.go.generate_presigned_url.args]
    bucket := flag.String("b", "", "The bucket")
    key := flag.String("k", "", "The object key")
	iam_role := flag.String("r", "", "The IAM role to execute the script with")
    flag.Parse()

    if *bucket == "" || *key == "" || *iam_role == ""{
        fmt.Println("You must supply a bucket name (-b BUCKET) and object key (-k KEY) and the iam role to execute the script (-r ROLE)")
        return
    }
    // snippet-end:[s3.go.generate_presigned_url.args]

    // snippet-start:[s3.go.generate_presigned_url.session]
    sess := session.Must(session.NewSessionWithOptions(session.Options{
        SharedConfigState: session.SharedConfigEnable,
	}))

    // snippet-end:[s3.go.generate_presigned_url.session]

    urlStr, err := GetPresignedURL(sess, bucket, key, iam_role)
    if err != nil {
        fmt.Println("Got an error retrieving a presigned URL:")
        fmt.Println(err)
        return
    }

	//get_policy()

    // snippet-start:[s3.go.generate_presigned_url.print]
    fmt.Println("The presigned URL: " + urlStr + " is valid for 15 minutes")
    // snippet-end:[s3.go.generate_presigned_url.print]
}
// snippet-end:[s3.go.generate_presigned_url]
