# Using the Google Cloud Platform in Delphi
This article covers how to use the Google Cloud Platform in conjunction with the Google Compute Engine to call various Google APIs.  In this article we show how to call the new Speech-To-Text API from a backend instance running on the Google Compute Engine.

If you are creating services for the cloud these days then you are probably familiar with [Amazon's AWS](https://aws.amazon.com/) and [Microsoft's Azure](https://azure.microsoft.com).  Google has their own offering called the [Google Compute Engine](https://cloud.google.com/compute/) (GCE) where you can deploy and operate your services in the cloud and leverage their numerous and excellent [Google Cloud Platform](https://cloud.google.com/) (GCP) APIs directly from your service.

In addition to offering virtual instances on a variety of operating systems such as Windows Server and various Linux flavors, the Google Cloud Platform provides numerous APIs for everything from managing your instances, message brokers, logging, data buckets, speech to text and lots more. 

Here at Grijjy we have grown to love the Google Compute Engine and Google Cloud Platform for deploying virtual instances.  It is an excellent, stable and high performance platform that you can configure to implement almost any type of scalable and distributed cloud based service.

For more information about us, our support and services visit the [Grijjy homepage](http://www.grijjy.com) or the [Grijjy developers blog](http://blog.grijjy.com).

The example contained here depends upon part of our [Grijjy Foundation library](https://github.com/grijjy/GrijjyFoundation).

The source code and related example repository is hosted on GitHub at [https://github.com/grijjy/DelphiGoogleAPI](https://github.com/grijjy/DelphiGoogleAPI).

# Introduction
In this primer we will be focusing on how to interact between services you create in Delphi that run on the Google Compute Engine and the Google Cloud Platform APIs.

As an example we will show how to use the basics of Google's Speech to Text API.  

We will introduce the TgoGoogle base class which handles the aspects of OAuth2, Java Web Tokens and uses Grijjy's scalable TCP and HTTP/S socket classes that are designed for Windows and Linux.  

> Note: The examples contained here do not necessarily rely on a virtual instance running in the Google Compute Engine.  Many of the APIs can be called remotely using the same Delphi code running on your desktop.

# Getting Started with the Google Cloud Platform
You can get started by visiting https://cloud.google.com and creating an account.  Your homepage for the Google Cloud Platform will be at, https://console.cloud.google.com/home

If you are also looking to deploy virtual instances then you will need to start a Google Compute Engine trial at, https://cloud.google.com/compute/

### Step 1. Create a Project
Before you can get started with the Google Cloud Platform you must create a project.

### Step 2. Create Credentials in the API Manager
You will need to use the API Manager to create Credentials so that your service is able to interact with the Google Cloud Platform APIs. To create credentials, visit the [API Manager](https://console.cloud.google.com/apis) page and click on **Credentials** and choose **Create credentials**.

![](http://i.imgur.com/8lyzfxZ.png)

Since we are creating credentials that we intend to use to communicate between our service and the Google Cloud APIs we select the option for **Service account key**.

### Step 3. Manage service accounts
Next we click **Manage service accounts** as shown below.
![](http://i.imgur.com/uCAqEhT.png)

This brings up the list of service accounts.
![](http://i.imgur.com/k1k85PA.png)
Take note of the **Compute Engine** default service account.  This email address, in the format of 1234567890-compute@developer.gserviceaccount.com is what we use in our code for our `TgoGoogle.ServiceAccount` field.

### Step 4. Create a certificate key
Next we select the **Options** to **Create key** and select the **P12** key type.
![](http://i.imgur.com/Lv3OiJN.png)

### Step 5. Convert P12 key to a PEM key
Since TgoGoogle uses a PEM key we need to convert the P12 key.  You can do this using OpenSSL binaries on any platform.

```shell
openssl pkcs12 -in path/to/key.p12 --out path/to/key.pem nodes -nocerts -passin pass:notasecret
```
The PEM key file is used with the `TgoGoogle.PrivateKey` field.

That's it.  Once you have the service account email address and the PEM key file you are ready to experiment with the Google Cloud Platform APIs from your service.

# TgoGoogle Class
The TgoGoogle class implements the [OAuth2 access token](https://cloud.google.com/storage/docs/authentication) requirements including periodic expiration and re-authorization silently.  It also implements [Java Web Tokens](https://jwt.io/) using OpenSSL that are compatible with [Google Cloud Platform API requirements](https://cloud.google.com/compute/docs/api/how-tos/api-requests-responses) (RSA with SHA256).  

All of this is layered over our [scalable client socket framework](https://blog.grijjy.com/2017/01/09/scalable-https-and-tcp-client-sockets-for-the-cloud/) for Windows and Linux so we can scale up transactions from our service.

The TgoGoogle class abstracts the effort of managing the OAuth access token internally.

```Delphi
  TgoGoogle = class
  public
    constructor Create;
    destructor Destroy; override;
  public
    { Post a request to the Google Cloud APIs }
    function Post(const AUrl, ARequest: String; out AResponseHeaders, AResponseContent: String;
      const ARecvTimeout: Integer = DEFAULT_TIMEOUT_RECV): Integer;
  public
    { Returns the current access token }
    property AccessToken: String read GetAccessToken;

    { Get or set the current engine scope }
    property OAuthScope: String read FOAuthScope write SetOAuthScope;

    { Get or set the current service account }
    property ServiceAccount: String read FServiceAccount write SetServiceAccount;

    { Get or set the current private key }
    property PrivateKey: String read FPrivateKey write SetPrivateKey;
  end;
```

## TgoGoogle: Create an instance of the class
To get started, create an instance of the TgoGoogle class.

```Delphi
var
  Google: TgoGoogle;
begin
  Google := TgoGoogle.Create;
end;
```

## TgoGoogle: Apply your service account and your private key 
Assign the service account (the email address for the compute engine) and the private key you created previously.

```Delphi
  Google.ServiceAccount := '1234567890-compute@developer.gserviceaccount.com';
  Google.PrivateKey := TFile.ReadAllText('my.pem');
```
You can load the PEM file in Delphi using System.IOUtils and using the TFile.ReadAllText method.

## TgoGoogle: Choose a Google scope for the API
You must assign the OAuth 2.0 scope for the respective Google API you want to utilize.  For a list of various Google scopes, see [https://developers.google.com/identity/protocols/googlescopes](https://developers.google.com/identity/protocols/googlescopes).

For the core cloud-platform APIs that we are using from a Google Compute Engine instance we use the following scope, 
```Delphi
  Google.OAuthScope := 'https://www.googleapis.com/auth/cloud-platform';
```

# Getting started with the Speech To Text API
Google has an excellent getting started page for Speech to Text, so we are going to use it as a basis for our example.  [https://cloud.google.com/speech/docs/getting-started](https://cloud.google.com/speech/docs/getting-started)

The example includes the following JSON which is the body the HTTP/REST request,
```javascript
{
  'config': {
      'encoding':'FLAC',
      'sampleRate': 16000,
      'languageCode': 'en-US'
  },
  'audio': {
      'uri':'gs://cloud-samples-tests/speech/brooklyn.flac'
  }
}
```

### To post a request to the Speech to Text API
You must provide the correct URL that relates to the Google REST API, followed by the content body of the HTTP request in the proper format.  In the case of the Speech To Text API, the body of is a properly formatted JSON document. 

```Delphi
StatusCode := Google.Post('https://speech.googleapis.com/v1beta1/speech:syncrecognize',
  <Json>, Headers, Content);
```
If the above Post succeeds, then `StatusCode` will return `200 (OK)` and `Content` will be a JSON document containing the result.  Any response headers will be returned in `Headers`.

> Note: The Speech To Text API can take time to convert depending upon the length of sequence, so you may have to increase the default timeout of 5000ms to a greater value when you call the Google.Post method.

You can find an [example Delphi application](https://github.com/grijjy/DelphiGoogleAPI) in our GitHub repository.

#License

TgoGoogle and DelphiGoogleAPI is licensed under the Simplified BSD License. See License.txt for details.