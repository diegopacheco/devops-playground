CREATE EXTENSION IF NOT EXISTS tin;

CREATE TABLE articles (
  id bigserial PRIMARY KEY,
  title text NOT NULL,
  category text NOT NULL,
  body text NOT NULL
);

INSERT INTO articles (title, category, body) VALUES
('Java virtual threads in production', 'programming', 'Java 21 virtual threads let a server handle thousands of blocking calls. Each virtual thread is a cheap object scheduled by the JVM, so the programming model stays simple while the code scales.'),
('Writing a Java class the right way', 'programming', 'A good Java class hides its fields, exposes a small method surface and keeps every object immutable when it can. Records remove most of the boilerplate code.'),
('Java garbage collectors compared', 'programming', 'G1, ZGC and Shenandoah trade throughput for pause time. ZGC keeps pauses under a millisecond even with a heap of hundreds of gigabytes of Java objects.'),
('Visiting Java island', 'travel', 'Java is the most populated island of Indonesia. From Jakarta you can reach the Borobudur temple and the volcanoes of east Java, close to Sumatra and Bali.'),
('Java coffee tasting notes', 'coffee', 'Java coffee from the Indonesian highlands is earthy, heavy and low in acidity. Aged beans called Old Java were stored in warehouses for years before roasting.'),
('Rust ownership explained', 'programming', 'Rust checks ownership and borrowing at compile time, so memory safety comes without a garbage collector. The borrow checker rejects data races before the code runs.'),
('Go channels and goroutines', 'programming', 'Go runs goroutines on a small pool of operating system threads. Channels pass values between goroutines and make concurrent code read like sequential code.'),
('Postgres MVCC in one page', 'databases', 'PostgreSQL keeps multiple versions of each row. Every transaction sees a snapshot, readers never block writers, and VACUUM removes dead tuples that no snapshot can see.'),
('How a full text search index works', 'databases', 'A full text search index maps every term to a posting list of documents. Queries intersect or merge posting lists, and BM25 ranks the documents by term frequency and document length.'),
('BM25 ranking without the math', 'databases', 'BM25 rewards documents where a rare term appears often, but saturates so the tenth occurrence adds little. Long documents are normalized so they do not win just by being long.'),
('Sharding Postgres', 'databases', 'Sharding splits a large table across many Postgres servers by a shard key. A good shard key keeps related rows together so most queries touch a single shard.'),
('Home brewing an IPA', 'beer', 'An IPA needs pale malt, plenty of hops and a clean yeast. Dry hopping after fermentation adds aroma without bitterness. Brewing takes about four weeks from mash to glass.'),
('Hops, malt and yeast', 'beer', 'Every beer is built from hops, malt and yeast. The malt gives sugar, the yeast turns sugar into alcohol and the hops balance the sweetness with bitterness.'),
('Belgian brewery tour', 'beer', 'The brewery tour visited three Belgian breweries brewing Trappist ales. Each brewer let us taste the beer straight from the fermentation tank.'),
('Lager versus ale', 'beer', 'Lager yeast ferments cold and slow, ale yeast ferments warm and fast. The difference in yeast and temperature explains most of the flavor gap.'),
('Jalapeño poppers', 'cooking', 'Cut each jalapeño in half, remove the seeds, fill it with cream cheese and bake it until the edges blister. Serve the jalapeños with a cold beer.'),
('Crème brûlée at home', 'cooking', 'A crème brûlée needs egg yolks, cream, sugar and vanilla. Bake it in a water bath and burn the sugar crust with a torch right before serving.'),
('Açaí bowl breakfast', 'cooking', 'Blend frozen açaí with banana, top it with granola and fresh fruit. Açaí comes from a palm tree in the Amazon and tastes like berries and chocolate.'),
('Threat modeling a web app', 'security', 'Threat modeling lists what can go wrong before the code ships. For each vulnerability the team rates the risk and picks a mitigation, starting with authentication and input validation.'),
('Security scanner pricing', 'security', 'Buy security at discount pricing, zero risk, cancel anytime. Our scanner finds every vulnerability in minutes and the annual subscription includes the enterprise plan.'),
('Patching a critical vulnerability', 'security', 'When a critical vulnerability is published, the security team measures the risk, patches exposed servers first and watches the logs for an exploit attempt.'),
('Zero trust networks', 'security', 'Zero trust treats every request as hostile until it proves its identity. It lowers the risk of lateral movement after one machine is compromised.'),
('Machine learning on tabular data', 'ml', 'Gradient boosted trees still beat deep learning on most tabular data. Good training data and careful feature work matter more than the model family.'),
('Neural network basics', 'ml', 'A neural network stacks layers of weighted sums and nonlinear functions. Training data and backpropagation adjust the weights to improve model accuracy.'),
('Measuring model accuracy', 'ml', 'Model accuracy alone hides class imbalance. Precision, recall and a held out test set tell you whether the machine learning model really generalizes.'),
('Methods and results of a caching study', 'research', 'Methods: we replayed one week of production traffic against three cache policies. Results: LRU with a small admission filter cut misses by thirty percent. Discussion follows the results.'),
('A study with results first', 'research', 'Results: the new index halved query latency. Methods: we ran the benchmark twice on the same machine. Discussion: the gain comes from skipping pages.'),
('Kubernetes operators', 'devops', 'An operator encodes the runbook of a stateful system as code. It watches custom resources and reconciles the cluster toward the desired state.'),
('Observability with metrics logs and traces', 'devops', 'Metrics show that something is wrong, logs show what happened and traces show where the time went. Together they cut the time to find a failing service.'),
('Emoji in search 😀', 'misc', 'The team celebrated the release with a 🍺 and a 😀 in the chat. A good tokenizer indexes emoji as terms so they are searchable like words.');

CREATE INDEX articles_body_tin ON articles USING tin (body);
