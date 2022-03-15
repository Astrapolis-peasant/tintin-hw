import { hw5 } from "../../declarations/hw5";

async function load_name() {
  let username = document.getElementById("username");
  let name = await hw5.get_name();
  username.innerText = name;
}

async function post() {
  document.getElementById("error").innerText = "";
  let post_button = document.getElementById('post');
  post_button.disabled = true;
  let text = document.getElementById('message').value;
  let otp = document.getElementById('otp').value;
  try {
    await hw5.post(text, otp);
  } catch (err) {
    console.log(err);
    document.getElementById("error").innerText = "Post Failed";
  }
  
  post_button.disabled = false;
}

var num_posts = 0;
async function load_posts() {
  let posts_section = document.getElementById("posts");
  let posts = await hw5.posts();
  if (num_posts != posts.length) {
    posts_section.replaceChildren([]);
  } else {
    return;
  }
  num_posts = posts.length;
  for (var i=0; i < posts.length; i++) {
    let row = document.createElement("tr");

    let author = document.createElement('td');
    author.innerText = posts[i].author;
    let time = document.createElement('td');
    time.innerText = Date(Number(posts[i].time)/1000);;
    let post = document.createElement('td');
    post.innerText = posts[i].msg;

    row.appendChild(author);
    row.appendChild(time);
    row.appendChild(post);
    posts_section.appendChild(row);
  }
}

function load() {
  load_name();
  let post_button = document.getElementById("post");
  post_button.onclick = post;
  load_posts();
  setInterval(load_posts, 3000);
}

window.onload = load;