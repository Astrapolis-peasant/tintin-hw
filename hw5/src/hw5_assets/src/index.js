import { hw5 } from "../../declarations/hw5";
import {createActor} from "../../declarations/hw5/index.js";
import { Principal } from '@dfinity/principal';

async function load_name() {
  let username = document.getElementById("username");
  let name = await hw5.get_name();
  username.innerText = name;
}

async function post() {
  document.getElementById("post_error").innerText = "";
  let post_button = document.getElementById('post');
  post_button.disabled = true;
  let textarea = document.getElementById('message');
  let text = textarea.value;
  let otp = document.getElementById('otp').value;
  try {
    await hw5.post(text, otp);
    textarea.value = "";
  } catch (err) {
    console.log(err);
    document.getElementById("post_error").innerText = "Post Failed";
  }
  post_button.disabled = false;
}

async function follow() {
  document.getElementById("follow_error").innerText = "";
  let follow_button = document.getElementById('follow');
  follow_button.disabled = true;
  let follow_input = document.getElementById('principal_id');
  let text = follow_input.value;
  let otp = document.getElementById('otp').value;
  try {
    await hw5.follow(Principal.fromText(text), otp);
    follow_input.value = "";
  } catch (err) {
    console.log(err);
    document.getElementById("follow_error").innerText = "Follow Failed";
  }
  
  follow_button.disabled = false;
}

var num_follows = 0;
var follows = [];
async function load_follows() {
  let follows_section = document.getElementById("follows");
  follows = await hw5.follows();
  if (num_follows != follows.length) {
    follows_section.replaceChildren([]);
  } else {
    return;
  }
  num_follows = follows.length;
  for (var i=0; i < follows.length; i++) {
    let row = document.createElement("tr");
    let principal_id = document.createElement('td');
    principal_id.innerText = follows[i];

    let actor = createActor(follows[i]);
    let name = document.createElement('td');

    try {
      name.innerText = await actor.get_name();
    } catch (err) {
      console.log(err);
      name.innerText = "failed to fetch name";
    }

    row.appendChild(name);
    row.appendChild(principal_id);
    follows_section.appendChild(row);
  }
}

function render_posts(section, posts) {
  for (var i=0; i < posts.length; i++) {
    let row = document.createElement("tr");

    let author = document.createElement('td');
    author.innerText = posts[i].author;
    let time = document.createElement('td');
    let datatime = new Date(Number(posts[i].time)/1e6);
    time.innerText = datatime.toLocaleDateString("en-US") + " " + datatime.toLocaleTimeString("en-US");
    let post = document.createElement('td');
    post.innerText = posts[i].text;

    row.appendChild(author);
    row.appendChild(time);
    row.appendChild(post);
    section.appendChild(row);
}
}

var num_posts = 0;
async function load_posts() {
  let posts_section = document.getElementById("posts");
  let posts = await hw5.posts(1);
  if (num_posts != posts.length) {
    posts_section.replaceChildren([]);
  } else {
    return;
  }
  num_posts = posts.length;
  render_posts(posts_section, posts);
}

var num_timeline = 0;
async function load_timeline() {
  var timeline = [];
  let timeline_section = document.getElementById("timeline");
  for (var i=0; i < follows.length; i++) {
    let actor = createActor(follows[i]);

    try {
      let posts = await actor.posts(1);
      timeline = timeline.concat(posts);
    } catch (err) {
      console.log(err);
    }
  }

  if (num_timeline != timeline.length) {
    timeline_section.replaceChildren([]);
  } else {
    return;
  }
  num_timeline = timeline.length;
  render_posts(timeline_section, timeline);
}

function load() {
  load_name();
  let post_button = document.getElementById("post");
  post_button.onclick = post;
  let follow_button = document.getElementById("follow");
  follow_button.onclick = follow;
  load_posts();
  load_follows();
  load_timeline();
  setInterval(load_posts, 3000);
  setInterval(load_follows, 3000);
  setInterval(load_timeline, 3000);
}

window.onload = load;