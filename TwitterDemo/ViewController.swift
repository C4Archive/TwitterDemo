//
//  ViewController.swift
//  TwitterDemo
//
//  Created by travis on 2016-04-21.
//  Copyright © 2016 C4. All rights reserved.
//

import UIKit
import TwitterKit
import Fabric

class ViewController: UIViewController {
    var logInButton: TWTRLogInButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: Base this Tweet ID on some data from elsewhere in your app
        setAppearance()
        TWTRAPIClient().loadTweetWithID("631879971628183552") { (tweet, error) in
            if let unwrappedTweet = tweet {
                let tweetView = TWTRTweetView(tweet: unwrappedTweet)
                tweetView.center = CGPointMake(self.view.center.x, self.topLayoutGuide.length + tweetView.frame.size.height / 2);
                self.view.addSubview(tweetView)

                let tweetView2 = TWTRTweetView(tweet: unwrappedTweet)
                tweetView2.center = CGPointMake(self.view.center.x, self.topLayoutGuide.length + tweetView.frame.size.height / 2 + tweetView.frame.size.height + 10);
                self.view.addSubview(tweetView2)

            } else {
                NSLog("Tweet load error: %@", error!.localizedDescription);
            }
        }
    }

    //This is how you style an individual tweet view
    func setStyle(tweetView: TWTRTweetView) {
//        tweetView.theme = .Dark
        tweetView.primaryTextColor = UIColor.yellowColor()
        tweetView.backgroundColor = UIColor.blueColor()
        
    }

    func setAppearance() {
//        TWTRTweetView.appearance().theme = .Dark
        TWTRTweetView.appearance().primaryTextColor = UIColor.yellowColor()
        TWTRTweetView.appearance().backgroundColor = UIColor.blueColor()
        TWTRTweetView.appearance().linkTextColor = UIColor.redColor()
    }

    func loadDemo() {
        logInButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                print("signed in as \(session?.userName)");
            } else {
                print("error: \(error?.localizedDescription)");
            }
        })
        logInButton.center = self.view.center

        logInButton.logInCompletion = { (session, error) in
            self.didLogIn()
            //            self.singleJackTweet()
            //            self.loadUserImage()
                        self.clientRequest()
        }

        self.view.addSubview(logInButton)
    }

    func didLogIn() {
        print("logged in!")
        logInButton.removeFromSuperview()
    }

    func singleJackTweet() {
        let userID = Twitter.sharedInstance().sessionStore.session()?.userID
        let client = TWTRAPIClient(userID: userID)
        client.loadTweetWithID("20") { tweet, error in
            print(tweet)
        }
    }

    func loadUser() {
        if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
            let client = TWTRAPIClient(userID: userID)
            client.loadUserWithID(userID) { (user, error) in
                print(user)
            }
        }
    }

    func loadUserImage() {
        if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
            let client = TWTRAPIClient(userID: userID)
            client.loadUserWithID(userID) { (user, error) in
                print(user)
                print(user?.profileImageURL)
                if let userImageURL = user?.profileImageURL {
                    let nsurl = NSURL(string: userImageURL)
                    UIApplication.sharedApplication().openURL(nsurl!)
                }
            }
        }
    }

    func clientRequest() {
        if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
            let client = TWTRAPIClient(userID: userID)
            client.loadUserWithID(userID) { (user, error) in
                let req = client.URLRequestWithMethod("GET", URL: "https://api.twitter.com/1.1/statuses/user_timeline.json", parameters: nil, error: nil)
                client.sendTwitterRequest(req, completion: { (response, data, error) in
                    if let d = data {
                        do {
                            let json = try NSJSONSerialization.JSONObjectWithData(d, options: [.AllowFragments,.MutableContainers,.MutableContainers]) as! [[String:AnyObject]]
                            print(json[0])
                        } catch {
                            print("there was a json error")
                        }
                    }
                })
            }
        }
    }
}

