const logGreetingEveryFiveSeconds = () => {
  console.log(`${new Date().toISOString()} - Hello, world!`);
  setTimeout(logGreetingEveryFiveSeconds, 5000);
};

logGreetingEveryFiveSeconds();