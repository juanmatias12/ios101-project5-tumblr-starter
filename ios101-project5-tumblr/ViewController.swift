//
//  ViewController.swift
//  ios101-project5-tumbler
//

import UIKit
import Nuke

class ViewController: UIViewController, UITableViewDataSource {
    
    func removeHTMLTags(from string: String) -> String {
        var newString = string
        let replacements = [
            "<p>": "", "</p>": "\n",
            "<br>": "\n", "<br/>": "\n",
            // Add more replacements as needed
        ]

        for (htmlTag, replacement) in replacements {
            newString = newString.replacingOccurrences(of: htmlTag, with: replacement, options: .caseInsensitive, range: nil)
        }

        return newString.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("🍏 numberOfRowsInSection called with posts count: \(posts.count)")
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostsCell", for: indexPath) as! PostsCell
        let post = posts[indexPath.row]

        // Assuming you want to display the first photo of each post
        if let firstPhoto = post.photos.first {
            Nuke.loadImage(with: firstPhoto.originalSize.url, into: cell.postsImageView)
        }

        // Configure the text labels
        cell.postsLabel.text = post.summary
        cell.overviewLabel.text = removeHTMLTags(from: post.caption)

        return cell
    }


    
    private var posts: [Post] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        

        
        fetchPosts()
    }



    func fetchPosts() {
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk")!
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                print("❌ Response error: \(String(describing: response))")
                return
            }

            guard let data = data else {
                print("❌ Data is NIL")
                return
            }

            do {
                let blog = try JSONDecoder().decode(Blog.self, from: data)

                DispatchQueue.main.async { [weak self] in
                    
                    let posts = blog.response.posts
                    self?.posts = posts
                    self?.tableView.reloadData()
                    


                    print("✅ We got \(posts.count) posts!")
                    for post in posts {
                        print("🍏 Summary: \(post.summary)")
                    }
                }

            } catch {
                print("❌ Error decoding JSON: \(error.localizedDescription)")
            }
        }
        session.resume()
    }
}
