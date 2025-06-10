---
title: "Paper Summary: AWS MemoryDB"
subtitle: Summary of the scientific paper on AWS MemoryDB
author: Man Parvesh Singh Randhawa
date: "2024-11-05T21:39:14-08:00"
meta: true
math: true
toc: true
hideDate: false
hideReadTime: false
series: [paper-summaries]
tags: [distributed-database,redis]
draft: false
description: ""
---

**Abstract**: Amazon MemoryDB for Redis is a database service designed for
11 9s of durability with in-memory performance. In this paper, we
describe the architecture of MemoryDB and how we leverage opensource Redis, a popular data structure store, to build an enterprise grade cloud database. MemoryDB offloads durability concerns to
a separate low-latency, durable transaction log service, allowing
us to scale performance, availability, and durability independently
from the in-memory execution engine. We describe how, using this
architecture, we are able to remain fully compatible with Redis,
while providing single-digit millisecond write and microsecondscale read latencies, strong consistency, and high availability. MemoryDB launched in 2021.

Paper link: https://www.amazon.science/publications/amazon-memorydb-a-fast-and-durable-memory-first-cloud-database

## 1. Origin Story

For several applications that require fast response time, we use in-memory databases like Redis. AWS provides AWS Elasticache that runs redis, but it does not provide any guarantees for durability and consistency. So several AWS customers had to build their own complex pipelines to handle data loss in case of any failures.

MemoryDB was built to provide in-memory performance with durability, strong consistency, and high availability

## 2. Redis Arhitecture and Limitations

### 2.1. Architecture

Redis allows horizontal scaling and splits its key space into 16384 slots that are distributed across one or more shards as a part of the server setup. Each shard has a single primary and zero or more read-only replicas.

Discovering lock-to-shard mapping is implemented inside client logic.

Replication between primary and replica nodes is implemented as a passive logical replication[^1].

Another limitation in this architecture is that it doesn't allow all commands to be naively forwarded to replicas - commands that include some degree of randomization - like SPOP.

### 2.2. Challenges of Maintaining Durability and Consistency

During a failover scenario: Redis uses quorum-based approach for failure detection and new primary election. After a failover, a new primary can be elected within seconds, but the new primary might not have the most up-to-date data - because of async updates to this replica.

Redis implements a few mechanisms for lightweight persistence:
point-in-time snapshots, and an on-disk transaction log.

## 3. Achieving Durability and Consistency

A durable database system must ensure that once data is committed and acknowledged it can be read back. MemoryDB offloads durability by leveraging a distributed transaction log service. A transaction log provides low-latency and strongly consistent
commits across multiple AZs.

### 3.1. Decoupling Durability

Each shard in MemoryDB uses passive replication, where a primary replicates the mutative commands it executes to its transaction log. Specifically, MemoryDB intercepts the Redis replication
stream, chunks it into records, and sends each record to the transaction log. The replicas read the replication stream sequentially
from the transaction log and stream it into Redis. As a result, every
replica holds an eventually consistent copy of the data set.

### 3.2. Maintaining Consistency

MemoryDB provides linearizability by making propagation to the multi-AZ transaction log
synchronous. It follows the write-behind logging principle, which replicates the effects of the executed command instead of the original command.

Due to our choice of using passive replication, mutations are
executed on a primary node before being committed into the transaction log. If a commit fails, for example due to network isolation,
the change must not be acknowledged and must not become visible.

MemoryDB adds a layer of client blocking. After a client sends a mutation, the
reply from the mutation operation is stored in a tracker until the
transaction log acknowledges persistence and only then sent to the
client. Meanwhile, the Redis workloop can process other operations.
Non-mutating operations can be executed immediately but must
consult the tracker to determine if their results must also be delayed
until a particular log write completes. Hazards are detected at the
key level.

## 4. Availability, Recovery and Resilience

### 4.1. Leader Election

Leader election is built on top of the transaction service, which leads to the following benefits:
1. Liveness improvement over Redis cluster bus leader election
2. Strengthens consistency by strictly ensuring a single primary throughout failures including split-brain scenarios. A replica cannot become primary if it isn't up-to-date with the latest data.
3. Usage of the *append* API offered by the transaction log and its consistency property simplifies the overall design and maintenance of MemoryDB.

### 4.2. Recovery

#### 4.2.1. Data restoration

Redis internal data synchronization APIs are leveraged. During a failure scenario:
1. A replica loads a recent point-in-time snapshot
2. Replays subsequent transaction

MemoryDB periodically creates snapshots and stores in S3 for each replica independently.

#### 4.2.2. Off-box snapshotting:
Snapshots are taken of the in-memory data using the copy-on-write virtual memory management technique provided by the OS. A child process captures a point-in-time status of the data set and serializes into a snapshot file, asynchronously from the main process.

This can be CPU and memory-intensive, so MemoryDB uses separate replica machines for snapshotting that are not visible to consumers - so they can fully utilize the compute resources of these replicas.

## 5. Management Operations

### 5.1. Cluster Management

A multi-tenant control plane service manages a fleet of single-tenant clusters on behalf of customers. It spins up all the resources required for a customer cluster, like EC2 instances, keys insite KMS, network ACLs inside the provided VPC, etc.

### 5.2. Scaling

Rolling N+1 upgrade process is used: new nodes running with new software are provisioned one by one.

## 6. Validating and Maintaining Consistency at Scale

### 6.1. Consistency During Upgrades

N+1 rolling stragegy is used to maintian availability during upgrades. Replicas are replaced first and primary in the end.

To avoid failures during upgrades that might introduce new commands or similar changes, if a replica with an older engine version observes a replication stream originating from a newer version than what it's currently running, it stops consuming the transaction log.

### 6.2. Verifying Correctness

#### 6.2.1. Snapshots

All snapshots generate a checksum, and so does the transaction log - for the data stored. An off-box machine verifies that these checksums are the same, and only the correct replicas are made available to the customers.

#### 6.2.2. Consistency

Formal methods were used to check all components. S3 uses lightweight formal methods and TLA+. The internal transaction log service is verified using TLA+. MemoryDB is verified using P.[^2]

## 7. My thoughts on this paper

1. MemoryDB is a strong solution for developers who are looking for a database solution that provides in-memory speeds and don't want to compromise on consistency and durability.
1. The transaction log service seems to be an amazing solution that powers several AWS systems. Would be great to read a paper on it some day.
2. I'm curious to know what is the exact number for the write latency (the paper mentions single-digit milliseconds)
3. Would be interesting to read about the formal correctness strategy for such systems.

[^1]: a.k.a. eventually consistent
[^2]: I'm unfamiliar with all of these methods at the time of writing this article. Will read about these some day.